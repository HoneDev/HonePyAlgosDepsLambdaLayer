# In cloudshell


sudo yum install python3.12 -y
mkdir packages && cd packages || exit

python3.12 -m venv venv
source venv/bin/activate
pip install --upgrade pip

# For HoneOps AWS Lambda Layer
pip install pandas numpy boto3 pydantic tqdm scipy orjson anytree scikit-learn boto3-type-annotations typeguard -t python --no-compile --implementation cp --only-binary=:all:

cd python || exit
rm -r *.dist-info
find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
find . | grep -E "pyproject.toml$" | xargs rm -rf
find . | grep -E "setup.py$" | xargs rm -rf
find . | grep -E "scipy\misc\*.dat$" | xargs rm -rf
find . -type d -name "tests" | grep -vE "^\.\/numpy\/" | xargs rm -rf
cd .. || exit

# check size
# du -sh python/* | sort -h
zip -r honeops-lambda-package.zip python
aws s3 cp honeops-lambda-layer.zip s3://hone-files-internal-data/lambda/layers/honeops-lambda-layer:v4.zip

# For AWS Powertools Lambda Layer
rm -rf python
pip install "aws-lambda-powertools[tracer, parser]" -t python --no-compile --implementation cp --only-binary=:all:

cd python || exit
rm -r *.dist-info
find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
find . | grep -E "pyproject.toml$" | xargs rm -rf
find . | grep -E "setup.py$" | xargs rm -rf
cd .. || exit

zip -r aws-powertools-lambda-package.zip python
aws s3 cp aws-powertools-lambda-package.zip s3://hone-files-internal-data/lambda/layers/aws-powertools-lambda-layer:v1.zip