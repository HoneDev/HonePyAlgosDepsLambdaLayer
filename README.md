Includes minified and compiled python files for the layer.


```requirements
pandas==2.2.3
numpy==2.2.4
boto3==1.37.31
pydantic ==2.11.3
tqdm==4.67.1
scipy==1.15.2
orjson==3.10.16
anytree==2.13.0
scikit-learn==1.6.1
boto3-type-annotations==0.3.1
typeguard==4.4.2
```
Compiled using AWS Cloud shell
```bash
sudo yum install python3.12 -y
mkdir packages && cd packages || exit

python3.12 -m venv venv
source venv/bin/activate
pip install --upgrade pip

# For HoneOps AWS Lambda Layer
pip install -r requirements_lambda_layer.txt -t python --no-compile --implementation cp --only-binary=:all:

cd python || exit
rm -r *.dist-info
find . | grep -E "(/__pycache__$|\.pyc$|\.pyo$)" | xargs rm -rf
find . | grep -E "pyproject.toml$" | xargs rm -rf
find . | grep -E "setup.py$" | xargs rm -rf
find . | grep -E "scipy\misc\*.dat$" | xargs rm -rf
find . -type d -name "tests" | grep -vE "^\.\/numpy\/" | xargs rm -rf
cd .. || exit

zip -r honeops-lambda-package.zip python
aws s3 cp honeops-lambda-layer.zip <s3://your-bucket-name> --region <your-region>

```