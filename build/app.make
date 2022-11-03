#!/bin/bash
set -e

pwd | grep -q build || {
	echo "Необходимо производить запуск скрипта из папки build"; exit 1;
	}


. ./library.run

SCRIPT_TO_MAKE=${APPS_ROOT}/${APP_NAME}/build/package.build
SCRIPT_TO_COPY=${APPS_ROOT}/${APP_NAME}/build/copy.build
IMAGE_NAME=$(get_remove_value "IMAGE_NAME")
CONTAINER_NAME=$(get_remove_value "CONTAINER_NAME")
_UID=$(get_remove_value "U_ID")
_GID=$(get_remove_value "G_ID")


#--------------------------------------------------------------------------------------------------------------------------------
#  Получаем ID контейнера
#--------------------------------------------------------------------------------------------------------------------------------
get_container_id(){
	docker_id=$(docker ps | grep "${CONTAINER_NAME}" | head -1 | cut -d' ' -f1 )
	[ -z "${docker_id}" ] && docker_id=$(docker ps | grep "${CONTAINER_NAME}" | head -1 | cut -d' ' -f1 )
	echo "${docker_id}"
}


#--------------------------------------------------------------------------------------------------------------------------------
#  Останавливаем и удаляем контейнер
#--------------------------------------------------------------------------------------------------------------------------------
purge_running_container(){
	container_id="${1}"
	docker stop "${container_id}"
	docker rm "${container_id}"
}

#--------------------------------------------------------------------------------------------------------------------------------
# Подключаемся к контейнеру для сборки приложения в нем
#--------------------------------------------------------------------------------------------------------------------------------
mount_container_to_make(){
	script_to_run="${1}"
	run_with_root="${2:-no}"

	docker_running_id=$(docker ps | grep "${CONTAINER_NAME}" | head -1 | cut -d' ' -f1 )
	if [ -n "${docker_running_id}" ]; then
		echo "${APP_NAME}::Контейнер разработки ${CONTAINER_NAME}[${docker_running_id}] запущен."
		echo "${APP_NAME}::Производим подключение к контейнеру."
		show_line
		if [ -n "${script_to_run}" ] ; then
			docker exec "${docker_running_id}" "${script_to_run}"
		else
			if [ "${run_with_root}" = yes ]; then
				docker exec -it --user root:root "${docker_running_id}" /bin/bash
			else
				docker exec -it "${docker_running_id}" /bin/bash
			fi
		fi
	else
		docker_stopped_id=$(docker ps -a | grep "${CONTAINER_NAME}" | head -1 | cut -d' ' -f1 )
		if [ -n "${docker_stopped_id}" ]; then
			echo "${APP_NAME}::Контейнер разработки ${CONTAINER_NAME}[${docker_stopped_id}] смонтирован, но остановлен."
			echo "${APP_NAME}::Запускаем контейнер и производим подключение к нему..."
			show_line
			docker start "${docker_stopped_id}"
			if [ -n "${script_to_run}" ] ; then
				docker exec "${docker_stopped_id}" "${script_to_run}"
			else
				if [ "${run_with_root}" = yes ]; then
					docker exec -it --user root:root "${docker_stopped_id}" /bin/bash
				else
					docker exec -it "${docker_stopped_id}" /bin/bash
				fi
			fi

		else
			echo "${APP_NAME}::Контейнер ${CONTAINER_NAME} не смонтирован!"
		#	Если контейнер запущен или просто собран - удаляем его (так, как там могут быть ошибки)
			container_id="$(get_container_id)"
			[ -n "${container_id}" ] && purge_running_container "$(get_container_id)" &> /dev/null

			echo "${APP_NAME}::Производим запуск и монтирование контейнера и подключаемся к нему..."
			echo "МЫ ВНУТРИ КОНТЕЙНЕРА ${APP_NAME}"
			if [ -n "${script_to_run}" ] ; then
				docker run -it --user "${_UID}:${_GID}" --name "${CONTAINER_NAME}" \
				   --mount type=bind,src="$(dirname "$(pwd)")",dst="${APPS_ROOT}"/"${APP_NAME}" \
				   "${IMAGE_NAME}" "${script_to_run}" /bin/bash
			else
				_uid="${_UID}"; _gid="${_GID}"
				[ "${run_with_root}" = yes ] && _uid=root && _gid=root
				docker run -it --user "${_uid}:${_gid}" --name "${CONTAINER_NAME}" \
				   --mount type=bind,src="$(dirname "$(pwd)")",dst="${APPS_ROOT}"/"${APP_NAME}" \
				   "${IMAGE_NAME}" /bin/bash
			fi
			version_txt="v$(echo ${full_version} | tr -s ' ' '-')"
			${?} && docker commit "${CONTAINER_NAME}" "${IMAGE_NAME}:${version_txt}"
		fi
	fi
	show_line
}

case "${1}" in
	term|run|-t ) 	mount_container_to_make "" ;;
	root|-r) 		mount_container_to_make "" "yes" ;;
	build|-b) 		mount_container_to_make "${SCRIPT_TO_MAKE}" ;;
	copy|-c )  		mount_container_to_make "${SCRIPT_TO_COPY}" ;;
	*)	echo '-----------------------------------------------------'
		echo "Аргументы запуска:  "
		echo '-----------------------------------------------------'
		echo "build[-b] - сборка пакета и копирование его на роутер"
		echo "copy[-c]  - копирование уже собранного пакета на роутер"
		echo "term[-t]  - подключение к контейнеру без исполнения скриптов с правами по умолчанию."
		echo "root[-r]  - подключение к контейнеру без исполнения скриптов с правами root"
		echo '-----------------------------------------------------'
		;;
esac




