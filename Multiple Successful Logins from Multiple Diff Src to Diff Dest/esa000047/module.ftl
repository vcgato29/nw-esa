/*
Version: 3
*/
module ${module_id};

<#if module_debug>@Audit('stream')</#if>

@Name('${module_id}_Alert')
@RSAAlert(oneInSeconds=${module_suppress?c}, identifiers={"user_dst"})

SELECT * FROM Event(
			medium =32
			AND	ec_activity IN ('Logon')
			AND	ec_outcome='Success'
			AND	ip_src IS NOT NULL
			AND	ip_dst IS NOT NULL
			AND	user_dst IS NOT NULL 
		).std:groupwin(user_dst).win:time_length_batch(${time_window?c} seconds, ${count?c}).std:unique(ip_src,ip_dst) group by user_dst having count(*) = ${count?c};


@Name('${module_id}_Alert')
@RSAAlert(oneInSeconds=${module_suppress?c}, identifiers={"user_dst"})
		
SELECT * FROM Event(
			medium = 32
			AND	ec_activity IN ('Logon') 
			AND	ec_outcome='Success' 
			AND	host_src IS NOT NULL 
			AND	host_dst IS NOT NULL
			AND	user_dst IS NOT NULL 
		).std:groupwin(user_dst).win:time_length_batch(${time_window?c} seconds, ${count?c}).std:unique(host_src,host_dst) group by user_dst having count(*) = ${count?c};