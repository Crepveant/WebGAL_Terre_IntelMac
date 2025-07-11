echo "Welcome to build WebGAL Terre, the editor of WebGAL platform."
# 安装依赖
yarn install --frozen-lockfile --network-timeout=300000

# 清理
rm -rf release

mkdir release

# 进入 Terre 目录
cd packages/terre2
yarn run build-standalone:intl
cd dist
cp -r main.js  ../../../release
rm main.js
cd ../
cp -r public assets ../../release
cd ../../

# 进入 Origine 目录
cd packages/origine2
yarn run build
cp -rf dist/* ../../release/public/
cd ../../

# 克隆 WebGAL Android 模板
cd release/assets/templates/
git clone https://github.com/nini22P/WebGAL-Android.git
mv WebGAL-Android WebGAL_Android_Template
# MainActivity.kt 移动到主文件夹防止误删
mv WebGAL_Android_Template/app/src/main/java/com/openwebgal/demo/MainActivity.kt WebGAL_Android_Template/app/src/main/java/MainActivity.kt
cd ../../../

cd release

# 删除冗余文件
rm -rf public/games/*
rm -rf public/games/.gitkeep
rm -rf assets/templates/WebGAL_Template/game/video/*
rm -rf assets/templates/WebGAL_Template/game/video/.gitkeep
rm -rf assets/templates/WebGAL_Android_Template/.github
rm -rf assets/templates/WebGAL_Android_Template/.git
rm -rf assets/templates/WebGAL_Android_Template/.gitattributes
rm -rf assets/templates/WebGAL_Android_Template/app/src/main/assets/webgal/.gitkeep
rm -rf assets/templates/WebGAL_Android_Template/app/src/main/java/com

cd ../

# 复制文件
rm -rf packages/terre-android/app/src/main/assets/terre
mkdir -p packages/terre-android/app/src/main/assets/terre
mv release/* packages/terre-android/app/src/main/assets/terre

cd packages/terre-android

# 检查 key.properties 是否存在
if [ -f "key.properties" ]; then
    echo "key.properties file exists, start build release apk..."
    ./gradlew assembleRelease
    cd ../../
    mv packages/terre-android/app/build/outputs/apk/release/app-release.apk release/WebGAL_Terre_Android.apk
else
    echo "key.properties file does not exist, start build debug apk..."
    ./gradlew assembleDebug
    cd ../../
    mv packages/terre-android/app/build/outputs/apk/debug/app-debug.apk release/WebGAL_Terre_Android_debug.apk
fi

echo "WebGAL Terre is now ready to be deployed."