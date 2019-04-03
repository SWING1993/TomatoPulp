#工程路径
cd `dirname $0`; pwd
project_path=$(pwd)
#echo "工程路径为" ${project_path}

#工程名 将XXX替换成自己的工程名
project_name=TomatoPulp

#scheme名 将XXX替换成自己的scheme名
scheme_name=TomatoPulp
echo '///--------'
echo '/// 请指定构建配置'
echo '/// 1.Debug'
echo '/// 2.Release'
echo '///--------'
echo ''

#指定构建配置
read platform
if [ $platform == 1 ];
then
development_mode=Debug
else
development_mode=Release
fi

echo '///--------'
echo '/// 构建配置为'${development_mode}
echo '///--------'
echo ''

#判断build文件夹是否存在 不存在就创建
if [ ! -d build  ];
then
mkdir build
else
echo ''
fi

#build文件夹路径 不存在就创建
build_path=${project_path}/build
#导出.ipa文件所在路径
exportIpaPath=${build_path}/${development_mode}
#plist文件所在路径
exportOptionsPlistPath=${project_path}/TomatoPulp/Info.plist
echo '///-----------'
echo '/// build文件夹路径' ${build_path}
echo '/// 导出.ipa文件所在路径' ${exportIpaPath}
echo '/// plist文件所在路径' ${exportOptionsPlistPath}
echo '///-----------'
echo ''
echo '///-----------'
echo '/// 正在清理工程'
echo '///-----------'
#直接清除文件里的文件，简单粗暴
rm -rf ${build_path}/*
#xcodebuild \
#clean -configuration ${development_mode} -quiet  || exit
echo ''
echo '///--------'
echo '/// 清理完成'
echo '///--------'
echo ''
echo '///-----------'
echo '/// 正在编译工程:'${development_mode}
echo '///-----------'
echo ''
xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive -quiet  || exit

echo '///--------'
echo '/// 编译完成'
echo '///--------'
echo ''
echo '///----------'
echo '/// 开始ipa打包'
echo '///----------'
xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} -allowProvisioningUpdates \
-quiet || exit

if [ -e $exportIpaPath/$scheme_name.ipa ]; 
then
    echo '///----------'
    echo '/// ipa包已导出'
    echo '///----------'
    open $exportIpaPath
    else
    echo '///-------------'
    echo '/// ipa包导出失败 '
    echo '///-------------'
fi
echo '///------------'
echo '/// 打包ipa完成  '
echo '///-----------='
echo ''
echo '///-------------'
echo '/// 开始发布ipa包 '
echo '///-------------'
echo ''
echo '///-------------'
echo '/// 开始上传到蒲公英 '
echo '///-------------'
echo ''

#蒲公英aipKey
MY_PGY_API_K=4895e73abf35e7b1c73c25329bd87ddc
#蒲公英uKey
MY_PGY_UK=bdcc644596f9d8524c04e859cf6e2bbf
#上传蒲公英
result=$(curl -F "file=@${exportIpaPath}/${scheme_name}.ipa" -F "uKey=${MY_PGY_UK}" -F "_api_key=${MY_PGY_API_K}" https://qiniu-storage.pgyer.com/apiv1/app/upload)
echo $result

#获取蒲公英的回调 code
reusltCode=$(echo $result | jq '.code')

if [ $reusltCode == '0' ]; 
then
echo '///-------------'
echo '/// 已经上传到了蒲公英 '
echo '///-------------'
echo ''

#获取info.plist版本号
# buildShortVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${exportOptionsPlistPath})
# buildVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${exportOptionsPlistPath})
# versionText="云e宝"${buildShortVersion}"("${buildVersion}")"

#获取蒲公英回调
appName=$(echo $result | jq -r '.data.appName')
appVersion=$(echo $result | jq -r '.data.appVersion')
appBuildVersion=$(echo $result | jq -r '.data.appBuildVersion')
appUpdated=$(echo $result | jq -r '.data.appUpdated')
appQRCodeURL=$(echo $result | jq -r '.data.appQRCodeURL')
appShortcutUrl=$(echo $result | jq -r '.data.appShortcutUrl')
versionText=${appName}${appVersion}'('${appBuildVersion}')'

#发送到钉钉
curl 'https://oapi.dingtalk.com/robot/send?access_token=7e6f02c3087edd19362340532a116a1f98d5b4310dba34685560598dc3803ccf' \
-H 'Content-Type: application/json' \
-d '{ "at": {"atMobiles": ["18667905583"], "isAtAll": false}, "msgtype": "markdown", "markdown": {"title": "Orange发布", "text": "### '$versionText'已上传到蒲公英\n[点击下载](https://www.pgyer.com/'$appShortcutUrl')\n或扫描二维码下载\n > ![]('$appQRCodeURL')"}}'

curl 'http://118.24.216.163:8080/orange/message/send' \
-d 'messageToken=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiIyIiwiZXhwIjoxNTU1NjUyNjI2fQ.MwZuRFzlOLEqKADVjQ5sHEvRBZxAxIzAQqsymOJvOYk&title=Oranged发布&content=Orange已上传到蒲公英 \n版本号：'$appVersion'('$appBuildVersion') \n更新日期：'$appUpdated' \n下载地址：https://www.pgyer.com/'$appShortcutUrl
#else
#echo '取消发送到钉钉'
#fi

else
echo '///-------------'
echo '/// 上传到蒲公英失败 '
echo '///-------------'
echo ''
fi

exit 0

