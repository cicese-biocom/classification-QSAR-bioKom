[![made-with-knime](https://img.shields.io/badge/Made%20with-Knime-ffd700.svg)](https://www.knime.com/)
[![Made with Python](https://img.shields.io/badge/Python-=3.9-blue?logo=python&logoColor=white)](https://python.org "Go to Python homepage")
[![Conda](https://img.shields.io/badge/-conda-44A833?logo=anaconda&logoColor=FFFFFF&color=44A833)](https://docs.conda.io/en/latest/)
[![Java Version](https://img.shields.io/badge/Java->=1.8_u351-orange)](https://www.oracle.com/java/technologies/javase/8u351-relnotes.html)
[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://www.docker.com/)

# KNIME workflow to build classification models for QSAR studies

![classification-QSAR-bioKom_workflow](https://github.com/cicese-biocom/classification-QSAR-bioKom/assets/136017848/a90dcaff-d1ee-4d66-88db-be5742c5fce6)

## **Workflow installation**
Clone the repository using Git:
```
git clone https://github.com/cicese-biocom/classification-QSAR-bioKom.git
```
The directory structure of the workflow is as follows:
```
classification-QSAR-bioKom
├── classification-QSAR-bioKom.knwf     <- KNIME workflow.
├── environment.yml                     <- Python libraries requiered by the workflow.
├── Dockerfile                          <- Docker image with all the dependencies requiered by the workflow. 
├── docker-compose.yml                  <- Configuration of the Docker container requiered by the workflow. 
├── knime_preferences.epf               <- Configuration of the extensions required by the workflow. 
├── run_workflow.sh                     <- Example to execute the workflow. 
├── README.md                           <- README to use the workflow. 
```

### **Dependencies**
The major dependencies used in the workflow are as follows:

> - Java 1.8 u351 (or later). </br>
> - C++ Compiler: </br>
	Microsoft C++ Build Tools 14.34 (or later) for Windows, see details [here](https://visualstudio.microsoft.com/visual-cpp-build-tools/).</br>
	GNU GCC compiler for Linux, see details [here](https://gcc.gnu.org/).	
> - [Anaconda](https://www.anaconda.com/) or [Miniconda](https://docs.conda.io/projects/miniconda/en/latest/) to manage Python environments.
> - [KNIME Analytics Platform](https://www.knime.com/) with the following extensions: </br>
	Weka 3.7</br>
	KNIME Python Integration</br>
	KNIME Parallel Chunk Loop Nodes</br>
	KNIME Statistics Nodes (Labs)</br>
	KNIME Machine Learning Interpretability Extension</br>

The Python libraries used in the workflow are specified in `environment.yml`.

### **KNIME Python Integration extension configuration**

#### **Python environment configuration via conda**
The KNIME Python Integration requires a configured Python environment. We provide the steps to create a Python environment from an `environment.yml` file using conda:
```
1. conda env create -f environment.yml
2. conda activate KNIME
3. conda env list
```

#### **Extension configuration using KNIME GUI**
In the KNIME Analytics Platform Preferences, configure the Python environment under KNIME > Python as shown in the figure below. 
See [KNIME Python Integration Guide](https://docs.knime.com/latest/python_installation_guide/#_introduction) for more details.

![python_integration](https://github.com/cicese-biocom/classification-QSAR-bioKom/assets/136017848/c442850c-4599-4d0b-8306-989a4963c631)

### **Managing workflow using Docker container**
We provide the `Dockerfile` and `docker-compose.yml` files with all the dependencies and configurations required by the workflow.
#### Prerequisites:
1. Install Docker following the [Installation Guide](https://docs.docker.com/engine/installation/) for your platform.
2. Configure in the `docker-compose.yml` file the volumes for input and output files.

#### Build the Docker image locally from the next command line:
```
docker-compose build
```

## **Usage**
### **Input data format**
The input data are comma separated values (CSV) files containing the features (columns) corresponding to every instance (rows). One of the input CSV files correspond to the training dataset, whereas one or more CSV files could be given
as test datasets. For running the workflow, it should be specified the path where the training CSV file and test CSV file(s) are saved. See [here](https://drive.google.com/file/d/1lBCmGVzCgowK5Jm42zz1hiPqMOpN8HMG/view?usp=sharing) for example of input CSV files.

### Workflow parameters:

|Name|Type|Value|Description|
|----|----|----|----|
|PathTrainingFolder|String||Path to the directory containing the training CSV file.|
|PathTestFolder|String||Path to the directory containing the test (external) CSV files.|
|MCC_Threshold|Float|[0, 1]|Models with training MCC values greater than the threshold MCC value are selected to be assessed in test files|
|TargetFeature|String||Name of the feature to be used as target feature.|
|Feature_Entropy|Float|[0, 1]|Threshold to remove irrelevant features using an unsupervised Shannon Entropy (SE)-based filter. That threshold (%) is used to compute the cutoff value regarding the maximun entropy|
|Feature_Correlation|Float|[0, 1]|Threshold to remove redundant features using Spearman correlation.|
|Model_Correlation|Float|[0, 1]|Threshold to remove redundant models using Pearson correlation.|
|Perplexity|Integer||Value to be used to build the t-SNE graphics. Defaul value is 0, meaning that the perplexity value is equal to square root of the number of features.|
|Subset|String||List separated by comma with the name of the features to be used as best subset. If this list is not specified, the CFS selector is applied on the training CSV file.|
|Processors|Integer||Number of processor to be used in the workflow execution.|

### Run workflow from command line (Windows):
```
knime.exe -consoleLog -nosplash -nosave -reset -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="path/to/classification-QSAR-bioKom.knwf" -workflow.variable=PathTrainingFolder,path/to/csv/training/file,String -workflow.variable=PathTestFolder,path/to/csv/test/files,String -workflow.variable=MCC_Threshold,value,double -workflow.variable=TargetFeature,Feature_Name,String -workflow.variable=Feature_Entropy,Threshold_Value,double -workflow.variable=Feature_Correlation,Threshold_Value,double -workflow.variable=Model_Correlation,Threshold_Value,double -workflow.variable=Processors,Number_Processors,int 
```
For other platforms see [here](https://www.knime.com/faq#q12).

### **Run workflow on the Docker container**
```
docker-compose run --rm sh run_workflow.sh
```

For frequently asked questions (FQA): https://www.knime.com/faq

