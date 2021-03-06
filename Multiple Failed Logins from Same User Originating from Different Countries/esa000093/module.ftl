/*
Version: 3
*/
module ${module_id};

<#if module_debug>@Audit('stream')</#if>

@Name('${module_id}_Alert')

@RSAAlert(oneInSeconds=${module_suppress?c}, identifiers={"user_dst"})

SELECT * FROM  
			Event(
				medium = 32
			AND
				ec_activity='Logon' 
			AND 
				ec_outcome='Failure'
			AND 
				country_src IS NOT NULL
			AND 
				user_dst IS NOT NULL 
			).std:groupwin(user_dst).win:time_length_batch(${time_window?c} seconds, ${count?c}).std:unique(country_src) group by user_dst having count(*) = ${count?c};
