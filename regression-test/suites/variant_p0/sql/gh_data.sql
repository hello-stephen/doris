set exec_mem_limit=8G;
SELECT count() from ghdata;
SELECT cast(v:repo.name as string), count() AS stars FROM ghdata WHERE cast(v:type as string) = 'WatchEvent' GROUP BY cast(v:repo.name as string)  ORDER BY stars DESC, cast(v:repo.name as string) LIMIT 5;
SELECT max(cast(cast(v:`id` as string) as bigint)) FROM ghdata;
SELECT sum(cast(cast(v:`id` as string) as bigint)) FROM ghdata;
SELECT sum(cast(v:payload.member.id as bigint)) FROM ghdata;
SELECT sum(cast(v:payload.pull_request.milestone.creator.site_admin as bigint)) FROM ghdata;
SELECT sum(length(v:payload.pull_request.base.repo.html_url)) FROM ghdata;
SELECT v:payload.commits.author.name FROM ghdata ORDER BY k LIMIT 10;
SELECT v:payload.member.id FROM ghdata where cast(v:payload.member.id as string) is not null  ORDER BY k LIMIT 10;
-- select k, v:payload.commits.author.name AS name, e FROM ghdata as t lateral view  explode(cast(v:payload.commits.author.name as array<string>)) tm1 as e  order by k limit 5;
select k, v from ghdata WHERE cast(v:type as string) = 'WatchEvent'  order by k limit 10;
SELECT cast(v:payload.member.id as bigint), count() FROM ghdata where cast(v:payload.member.id as bigint) is not null group by cast(v:payload.member.id as bigint) order by 1, 2 desc LIMIT 10;


SELECT count() from github_events;
SELECT cast(v:repo.name as string), count() AS stars FROM github_events WHERE cast(v:type as string) = 'WatchEvent' GROUP BY cast(v:repo.name as string)  ORDER BY stars DESC, cast(v:repo.name as string) LIMIT 5;
SELECT max(cast(cast(v:`id` as string) as bigint)) FROM github_events;
SELECT sum(cast(cast(v:`id` as string) as bigint)) FROM github_events;
SELECT sum(cast(v:payload.member.id as bigint)) FROM github_events;
SELECT sum(cast(v:payload.pull_request.milestone.creator.site_admin as bigint)) FROM github_events;
SELECT sum(length(v:payload.pull_request.base.repo.html_url)) FROM github_events;
SELECT v:payload.commits.author.name FROM github_events ORDER BY k LIMIT 10;
SELECT v:payload.member.id FROM github_events where cast(v:payload.member.id as string) is not null  ORDER BY k LIMIT 10;
-- select k, v:payload.commits.author.name AS name, e FROM github_events as t lateral view  explode(cast(v:payload.commits.author.name as array<string>)) tm1 as e  order by k limit 5;
select k, v from github_events WHERE cast(v:type as string) = 'WatchEvent'  order by k limit 10;
SELECT cast(v:payload.member.id as bigint), count() FROM github_events where cast(v:payload.member.id as bigint) is not null group by cast(v:payload.member.id as bigint) order by 1, 2 desc LIMIT 10;