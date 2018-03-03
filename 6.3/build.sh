docker build -t registry.cn-hangzhou.aliyuncs.com/hybris-images/hybris-dev:hybris-6.3_v1 .
docker push registry.cn-hangzhou.aliyuncs.com/hybris-images/hybris-dev:hybris-6.3_v1
docker tag registry.cn-hangzhou.aliyuncs.com/hybris-images/hybris-dev:hybris-6.3_v1 zqiannnn/hybris-dev:hybris-6.3_v1
docker push zqiannnn/hybris-dev:hybris-6.3_v1