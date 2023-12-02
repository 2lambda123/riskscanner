
INSERT INTO plugin ( id, name, icon, update_time) VALUES ('fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'));

INSERT INTO rule_group (`name`, `description`, `level`, `plugin_id`, `flag`) VALUES ('GCP 安全检查', '安全检查，为您提供通信网络、计算环境和管理中心的网络安全检查。', '等保三级', 'fit2cloud-gcp-plugin', 1);

SELECT @groupId := LAST_INSERT_ID();

INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('1f3ef6ec-17ab-409d-9051-ea5c543312d1', 'Google Cloud 部署管理器扫描', 1, 'LowRisk', 'Google Cloud 检测账号下已达到到期日期的部署，未到期视为“合规”，否则属于“不合规”', 'policies:\n  # 检测账号下已达到到期日期的部署，未到期视为“合规”，否则属于“不合规”\n  - name: expired-deployments\n    description: Finds expired deployments\n    resource: gcp.dm-deployment\n    filters:\n    - type: value\n      key: insertTime\n      value_type: expiration\n      op: gte\n      value: ${{day}}', '[{\"key\":\"day\",\"name\":\"到期时间\",\"defaultValue\":\"7\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('34c7e619-6815-4c20-af8e-8d11b16a770c', 'Google Cloud SQL实例扫描', 1, 'HighRisk', 'Google Cloud 检测账号下Cloud SQL 实例的备份是否运行并列出超过 5 天的不成功备份，符合的视为“合规”，否则属于“不合规”', 'policies:\n# 检测账号下Cloud SQL 实例的备份是否运行并列出超过 5 天的不成功备份，符合的视为“合规”，否则属于“不合规”\n- name: sql-backup-run\n  description: |\n    check basic work of Cloud SQL filter on backup runs: lists unsucessful backups older than 5 days\n  resource: gcp.sql-backup-run\n  filters:\n    - type: value\n      key: status\n      op: not-equal\n      value: ${{status}}\n    - type: value\n      key: endTime\n      op: greater-than\n      value_type: age\n      value: ${{day}}', '[{\"key\":\"status\",\"name\":\"状态\",\"defaultValue\":\"SUCCESSFUL\",\"required\":true},{\"key\":\"day\",\"name\":\"天数\",\"defaultValue\":\"5\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('3a1a0fc7-98f3-4f8e-a434-76460ef2009b', 'Google Cloud DNS 策略日志记录扫描', 1, 'LowRisk', 'Google Cloud 检测账号下DNS 策略中的日志记录状态，未禁用视为“合规”，否则属于“不合规”', 'policies:\n    # 检测账号下DNS 策略中的日志记录状态，未禁用视为“合规”，否则属于“不合规”\n    - name: gcp-dns-policies-if-logging-disabled\n      resource: gcp.dns-policy\n      filters:\n        - type: value\n          key: enableLogging\n          value: ${{value}}', '[{\"key\":\"value\",\"name\":\"是否禁用\",\"defaultValue\":\"false\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('6923bc7a-fb4f-4c1c-ae70-dc6aac407e11', 'Google Cloud 负载均衡器扫描', 1, 'MediumRisk', 'Google Cloud 检测账号下负载均衡器是否有 TLS 1.2 版的 SSL 策略，符合的视为“合规”，否则属于“不合规”', 'policies:\n  # 检测账号下负载均衡器是否有 TLS 1.2 版的 SSL 策略，符合的视为“合规”，否则属于“不合规”\n  - name: gcp-load-balancing-ssl-policies\n    resource: gcp.loadbalancer-ssl-policy\n    filters:\n      - type: value\n        key: minTlsVersion\n        op: ne\n        value: ${{tsl}}', '[{\"key\":\"tsl\",\"name\":\"SSL 策略 TLS 版本\",\"defaultValue\":\"TLS_1_2\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('6939910d-a7f1-4347-9238-abce1111f45d', 'Google Cloud 域使用状态扫描', 1, 'MediumRisk', 'Google Cloud 检测账号下列入黑名单的域是否仍在使用中，未使用视为“合规”，否则属于“不合规”', 'vars:\n  blacklisted-domains-in-use: &blacklisted-domains\n    - ${{domains1}}\n    - ${{domains2}}\n    - ${{domains3}}\npolicies:\n  # 检测账号下列入黑名单的域是否仍在使用中，未使用视为“合规”，否则属于“不合规”\n  - name: gcp-app-engine-domain-if-blacklisted-in-use\n    resource: gcp.app-engine-domain\n    filters:\n      - type: value\n        key: id\n        op: in\n        value: *blacklisted-domains', '[{\"key\":\"domains1\",\"name\":\"域名1\",\"defaultValue\":\"appengine-de.mo\",\"required\":true},{\"key\":\"domains2\",\"name\":\"域名2\",\"defaultValue\":\"gcp-li.ga\",\"required\":true},{\"key\":\"domains3\",\"name\":\"域名3\",\"defaultValue\":\"whatever.com\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('7557ce1b-aacf-4cd7-bb19-6e411621daf3', 'Google Cloud 防火墙规则扫描', 1, 'LowRisk', 'Google Cloud 检测账号下防火墙规则是否符合规则，符合视为“合规”，否则属于“不合规”', 'vars:\n    min-network-prefix-size: &min-network-prefix-size ${{value2}}\npolicies:\n    # 检测账号下防火墙规则是否符合规则，符合视为“合规”，否则属于“不合规”\n    - name: appengine-firewall-rules\n      description: |\n        Check if firewall rule network prefix size is long enough\n      resource: gcp.app-engine-firewall-ingress-rule\n      filters:\n        - not:\n          - type: value\n            key: sourceRange\n            op: regex\n            # 过滤掉*特殊字符和没有网络前缀长度的IP地址\n            value: ${{value1}}\n          - type: value\n            key: sourceRange\n            value_type: cidr_size\n            op: ge\n            value: *min-network-prefix-size', '[{\"key\":\"value1\",\"name\":\"防火墙过滤规则(正则表达式)\",\"defaultValue\":\"\\\"^([0-9]{1,3}\\\\\\\\.){3}[0-9]{1,3}(\\\\\\\\/([0-9]|[1-2][0-9]|3[0-2]))?$\\\"\",\"required\":true},{\"key\":\"value2\",\"name\":\"长度\",\"defaultValue\":\"24\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('9312ca46-1ce9-4e42-86b2-7f9b5c0db090', 'Google Cloud 防火墙入口规则配置扫描', 1, 'LowRisk', 'Google Cloud 检测账号下防火墙规则是否只有一个规则允许所有连接，符合视为“合规”，否则属于“不合规”', 'policies:\n  # 检测账号下防火墙规则是否只有一个规则允许所有连接，符合视为“合规”，否则属于“不合规”\n  - name: gcp-app-engine-firewall-ingress-rule-if-default-unrestricted-access\n    resource: gcp.app-engine-firewall-ingress-rule\n    filters:\n      - and:\n        - type: value\n          value_type: resource_count\n          op: eq\n          value: ${{value}}\n        - type: value\n          key: sourceRange\n          value: \'*\'\n        - type: value\n          key: action\n          value: ALLOW', '[{\"key\":\"value\",\"name\":\"策略数量\",\"defaultValue\":\"1\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('95e46474-5611-4d82-a9c5-5da3398ad3a4', 'Google Cloud 实例模板扫描', 1, 'LowRisk', 'Google Cloud 检测账号下不符合要求的实例模板，符合的视为“合规”，否则属于“不合规”', 'vars:\n  # See https://cloud.google.com/compute/docs/machine-types\n  disallowed-machine-types: &disallowed-machine-types\n    - ${{value1}}\n    - ${{value2}}\n    - ${{value3}}\n    - ${{value4}}\n    - ${{value5}}\n\npolicies:\n  - name: gcp-instance-template-disallowed-machine-types\n    resource: gcp.instance-template\n    filters:\n      - type: value\n        key: properties.machineType\n        op: in\n        value: *disallowed-machine-types', '[{\"key\":\"value1\",\"name\":\"模板类型\",\"defaultValue\":\"\\\"f1-micro\\\"\",\"required\":true},{\"key\":\"value2\",\"name\":\"模板类型\",\"defaultValue\":\"\\\"g1-small\\\"\",\"required\":true},{\"key\":\"value3\",\"name\":\"模板类型\",\"defaultValue\":\"\\\"n1-highcpu-32\\\"\",\"required\":true},{\"key\":\"value4\",\"name\":\"模板类型\",\"defaultValue\":\"\\\"n1-highcpu-64\\\"\",\"required\":true},{\"key\":\"value5\",\"name\":\"模板类型\",\"defaultValue\":\"\\\"n1-highcpu-96\\\"\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('d147a425-ddd5-4826-b685-e3b3842ae253', 'Google Cloud SSL 证书过期扫描', 1, 'LowRisk', 'Google Cloud 检测账号下 SSL 证书是否即将到期，未到期视为“合规”，否则属于“不合规”', 'policies:\n    # 检测账号下 SSL 证书是否即将到期，未到期视为“合规”，否则属于“不合规”\n    - name: appengine-certificate-age\n      description: |\n        Check existing certificate\n      resource: gcp.app-engine-certificate\n      filters:\n      - type: value\n        key: expireTime\n        op: ${{op}}\n        value_type: expiration\n        value: ${{day}}', '[{\"key\":\"op\",\"name\":\"比较（大于/小于/等于）\",\"defaultValue\":\"less-than\",\"required\":true},{\"key\":\"day\",\"name\":\"天数\",\"defaultValue\":\"60\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('d2288b78-bab7-4195-9c16-79ae29b9f292', 'Google Cloud DNS 区域的资源扫描', 1, 'LowRisk', 'Google Cloud 检测账号下DNS 区域的资源中是否禁用了 DNSSEC，未禁用视为“合规”，否则属于“不合规”', 'policies:\n    # 检测账号下DNS 区域的资源中是否禁用了 DNSSEC，未禁用视为“合规”，否则属于“不合规”\n    - name: gcp-dns-managed-zones-if-no-dnssec\n      resource: gcp.dns-managed-zone\n      filters:\n        - type: value\n          key: dnssecConfig.state\n          # off without quotes is treated as bool False\n          value: ${{value}}', '[{\"key\":\"value\",\"name\":\"DNS的DNSSEC状态\",\"defaultValue\":\"\\\"off\\\"\",\"required\":true}]', 'fit2cloud-gcp-plugin', 'Google Cloud', 'gcp.png', concat(unix_timestamp(now()), '008'), 1, 'custodian');

INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('d147a425-ddd5-4826-b685-e3b3842ae253', 'cost');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('6939910d-a7f1-4347-9238-abce1111f45d', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('7557ce1b-aacf-4cd7-bb19-6e411621daf3', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('9312ca46-1ce9-4e42-86b2-7f9b5c0db090', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('1f3ef6ec-17ab-409d-9051-ea5c543312d1', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('d2288b78-bab7-4195-9c16-79ae29b9f292', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('3a1a0fc7-98f3-4f8e-a434-76460ef2009b', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('95e46474-5611-4d82-a9c5-5da3398ad3a4', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('6923bc7a-fb4f-4c1c-ae70-dc6aac407e11', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('34c7e619-6815-4c20-af8e-8d11b16a770c', 'safety');


INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('d147a425-ddd5-4826-b685-e3b3842ae253', '87');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('6939910d-a7f1-4347-9238-abce1111f45d', '62');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('1f3ef6ec-17ab-409d-9051-ea5c543312d1', '87');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('d2288b78-bab7-4195-9c16-79ae29b9f292', '91');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('3a1a0fc7-98f3-4f8e-a434-76460ef2009b', '91');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('95e46474-5611-4d82-a9c5-5da3398ad3a4', '91');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('6923bc7a-fb4f-4c1c-ae70-dc6aac407e11', '91');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('34c7e619-6815-4c20-af8e-8d11b16a770c', '91');


INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('d147a425-ddd5-4826-b685-e3b3842ae253', @groupId);
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('6939910d-a7f1-4347-9238-abce1111f45d', @groupId);
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('7557ce1b-aacf-4cd7-bb19-6e411621daf3', @groupId);
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('9312ca46-1ce9-4e42-86b2-7f9b5c0db090', @groupId);
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('1f3ef6ec-17ab-409d-9051-ea5c543312d1', @groupId);
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('d2288b78-bab7-4195-9c16-79ae29b9f292', @groupId);
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('3a1a0fc7-98f3-4f8e-a434-76460ef2009b', @groupId);
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('95e46474-5611-4d82-a9c5-5da3398ad3a4', @groupId);
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('6923bc7a-fb4f-4c1c-ae70-dc6aac407e11', @groupId);
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('34c7e619-6815-4c20-af8e-8d11b16a770c', @groupId);


INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('0388fcf8-e189-4f1b-9a34-927c02ea4c52', '3a1a0fc7-98f3-4f8e-a434-76460ef2009b', 'gcp.dns-policy');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('139696cc-b0f1-48d5-8f45-2d90aef61bdf', '6923bc7a-fb4f-4c1c-ae70-dc6aac407e11', 'gcp.loadbalancer-ssl-policy');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('19f7a070-b8fb-49fe-a4ea-df6a93af61fa', '9312ca46-1ce9-4e42-86b2-7f9b5c0db090', 'gcp.app-engine-firewall-ingress-rule');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('3fc5a259-888c-4a38-9bf9-120798bd1647', '1f3ef6ec-17ab-409d-9051-ea5c543312d1', 'gcp.dm-deployment');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('5a0bdd82-76be-4b8f-aac8-832e462762a9', '7557ce1b-aacf-4cd7-bb19-6e411621daf3', 'gcp.app-engine-firewall-ingress-rule');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('686da099-4b14-43e4-946d-5170e319369f', '95e46474-5611-4d82-a9c5-5da3398ad3a4', 'gcp.instance-template');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('72bba5c7-95ac-45b0-8482-afd104d27d27', '34c7e619-6815-4c20-af8e-8d11b16a770c', 'gcp.sql-backup-run');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('a6913598-a77c-483d-b94d-d652de8d4418', '6939910d-a7f1-4347-9238-abce1111f45d', 'gcp.app-engine-domain');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('b9aa8f0d-726f-4e06-a83a-e0c8202c121c', 'd2288b78-bab7-4195-9c16-79ae29b9f292', 'gcp.dns-managed-zone');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('cdcf14dd-8a76-4694-8271-25463a5ca0d3', 'd147a425-ddd5-4826-b685-e3b3842ae253', 'gcp.app-engine-certificate');