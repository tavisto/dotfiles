#!/usr/bin/env bash
ansible prod-sample -a 'rpm -qa bpapp* | sort' | sort -u | grep -v 'success' > /tmp/prod_package_list.txt
ansible stage-sample -a 'rpm -qa bpapp* | sort' | sort -u | grep -v 'success' > /tmp/stage_package_list.txt
diff  /tmp/prod_package_list.txt /tmp/stage_package_list.txt -y --left-column | awk  '{ print $3 }' | sort -u