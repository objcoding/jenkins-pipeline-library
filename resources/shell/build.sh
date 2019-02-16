#!/bin/bash

# env
branch=${1:-master}
registry="193.112.61.178:5000"
timestamp=`date +%Y%m%d%H%M%S`

# 检索出所有Dockerfile
Dockerfiles=`find -name Dockerfile`
echo "检索到Dockerfile：\n%s\n" "${Dockerfiles}"

j=0
for d in ${Dockerfiles} ; do
    ((j++))
done
echo "$j"
if [ "$j" -eq "0" ]; then
    echo '没有检索到Dokcerfile'
    exit 1
fi

# 检索到变更的module
files=`git diff --name-only HEAD~ HEAD`
echo "git提交的文件：\n%s\n" "${files[@]}"

# 单个module的项目
if [ "$j" -eq "1" ];
then
    module=`pwd`
    module=`echo ${module%_*}`
    module=`echo ${module##*/}`

    echo "构建镜像：$registry/$module:$branch-$timestamp"
    docker build --build-arg ACTIVE=${branch} -t ${registry}/${module}:${branch}-${timestamp} .
    echo "上传镜像（tiemstamp）：$registry/$module:$branch-$timestamp"
    docker push ${registry}/${module}:${branch}-${timestamp}
    echo "上传镜像（latest）：$registry/$module:$branch-latest"
    docker tag ${registry}/${module}:${branch}-${timestamp} ${registry}/${module}:${branch}-latest
    docker push ${registry}/${module}:${branch}-latest
    echo "构建完成！"

# 多个module的项目
else
    for module in ${Dockerfiles[@]}
    do
        module=`echo ${module%/*}`
        module=`echo ${module##*/}`
        if [[ $files =~ $module ]];then
            updatedModules[${#updatedModules[@]}]=`echo ${module}`
        fi
    done

    echo "准备操作的项目："
    echo "%s\n" "${updatedModules[@]}"
    if [ ${#updatedModules[@]} == 0 ]; then
        echo '不存在改动的项目'
        exit 1
    fi

    # build
    i=0
    for updatedModule in ${updatedModules[@]}
        do
            if [ "$i" -eq "0" ]; then
                cd ./$updatedModule
            else
                cd ../$updatedModule
            fi

            echo "构建镜像：$registry/$updatedModule:$branch-$timestamp"
            docker build --build-arg ACTIVE=${branch} -t ${registry}/${updatedModule}:${branch}-${timestamp} .
            echo "上传镜像（tiemstamp）：$registry/$updatedModule:$branch-$timestamp"
            docker push ${registry}/${updatedModule}:${branch}-${timestamp}
            echo "上传镜像（latest）：$registry/$updatedModule:$branch-latest"
            docker tag ${registry}/${updatedModule}:${branch}-${timestamp} ${registry}/${updatedModule}:${branch}-latest
            docker push ${registry}/${updatedModule}:${branch}-latest

            ((i++))
    done
    echo "构建完成！"
fi



