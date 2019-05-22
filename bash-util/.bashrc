# Fujitsu Network Communications
# Master .bashrc for Pearl River and
# Richardson Engineering Department

export DN=`/usr/bin/domainname`

if [ ${DN} ]; then
	case ${DN} in
	
		tddtx.fujitsu.com|tddeng00.fnts.com) \
		if [ -f /fnc/adm/etc/.bashrc.tx ];  then
			. /fnc/adm/etc/.bashrc.tx
		fi
		;;

		tddny.fujitsu.com) \
		if [ -f /fnc/adm/etc/.bashrc.ny ]; then
			. /fnc/adm/etc/.bashrc.ny
		fi
		;;

		chennai) \
		if [ -f /fnc/adm/etc/.bashrc.cin ]; then
			. /fnc/adm/etc/.bashrc.cin
		fi
		;;

	esac
fi

. ~/.bashrc_custom_profile
