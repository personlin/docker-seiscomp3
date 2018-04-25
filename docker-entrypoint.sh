#!/usr/bin/env bash
set -e

rsync -av $SEISCOMP3_CONFIG/ $INSTALL_DIR/
rsync -av $LOCAL_CONFIG/ /home/sysop/.seiscomp3/
rsync -av $INIT_STATE/ $INSTALL_DIR/etc/init/

case $1 in
    "")
        supervisord -c supervisord.conf
    ;;
    install-deps|setup|shell|enable|disable|start|stop|restart|check|status|list|exec|update-config|alias|print|help)
        exec gosu sysop seiscomp "$@"
    ;;
    *)
        exec "$@"
esac
