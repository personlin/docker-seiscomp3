#!/usr/bin/env bash
set -e

rsync -av $SEISCOMP3_CONFIG/ $INSTALL_DIR/
rsync -av $LOCAL_CONFIG/ $HOME/.seiscomp3/

case $1 in
    "")
        seiscomp start
        tail -f /dev/null
    ;;
    install-deps|setup|shell|enable|disable|start|stop|restart|check|status|list|exec|update-config|alias|print|help)
        exec seiscomp "$@"
    ;;
    *)
        exec "$@"
esac