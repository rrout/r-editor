# Fujitsu Network Communications
# Master .profile for Pearl River Chennai Sunnyvale and
# Richardson Engineering Department

export DN=`/bin/domainname`

if [ ${DN} ]; then
	case ${DN} in
	
	tddtx.fujitsu.com|tddeng00.fnts.com)  \
	if [ -f /fnc/adm/etc/.profile.tx ]; then
		. /fnc/adm/etc/.profile.tx
	fi
	;;

	tddny.fujitsu.com) \
	if [ -f /fnc/adm/etc/.profile.ny ]; then
		. /fnc/adm/etc/.profile.ny
	fi
	;;

        chennai)
        if [ -f /fnc/adm/etc/.profile.cin ]; then
                . /fnc/adm/etc/.profile.cin
        fi
        ;;

        nms.fnc.fujitsu.com)
        if [ -f /fnc/adm/etc/.profile.ca ]; then
                . /fnc/adm/etc/.profile.ca
        fi
        ;;

	esac
fi
