SELECT DISTINCT coalesce(u.name, 'not defined') AS name, 
	   coalesce(lastname, 'not defined') AS lastname,
	   b1.type, 
	   b1.volume, 
	   coalesce(c.name, 'not defined') AS currency_name,
	   coalesce((SELECT rate_to_usd FROM currency AS c WHERE c.id = c1.id AND c.updated = c1.last_update), 1) AS last_rate_to_usd,
	   b1.volume * coalesce((SELECT rate_to_usd FROM currency AS c WHERE c.id = c1.id AND c.updated = c1.last_update), 1) as total_volume_in_usd


FROM "user" AS u

FULL JOIN (SELECT user_id, SUM(money) AS volume, type, currency_id
 FROM balance
 GROUP BY user_id, type, currency_id
) AS b1 ON b1.user_id = u.id

FULL JOIN currency AS c ON c.id = b1.currency_id

FULL JOIN (SELECT id, name, MAX(updated) AS last_update
		   FROM currency
		   GROUP BY id, name
		  ) AS c1 ON c1.id = b1.currency_id
		  
ORDER BY 1 DESC, 2,3 