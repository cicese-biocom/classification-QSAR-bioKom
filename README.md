# KNIME workflow to build classification models for QSAR studies

![Figure 1](https://github.com/cicese-biocom/classification-QSAR-bioKom/assets/19722447/5c510e77-221b-4a4e-9e02-4a62a9f968f0)

## Installation guidlines:

1.	Install Java 1.8 u351 (or later). 
2.	Install C++ compiler:
	- Windows: Install Microsoft C++ Build Tools 14.34 (or later). See https://stackoverflow.com/questions/64261546/how-to-solve-error-microsoft-visual-c-14-0-or-greater-is-required-when-inst
	- Linux: https://gcc.gnu.org/
4.	Install the Anaconda program to manage Python environments.
5.	Create a conda environment named KNIME using python 3.9.
a.	conda create --name KNIME python=3.9
6.	Install the following packages in the environment created:
	- pip install numpy
	- pip install pillow
	- pip install -U kaleido
	- pip install plotly
	- pip install shap	
	- pip install python-javabridge
	- pip install python-weka-wrapper3
	- conda update pillow
	- conda install -c anaconda joblib
	- conda install -c anaconda scipy
	- conda install -c anaconda pandas
	- conda install -c anaconda scikit-learn
	- conda install -c anaconda git
	- conda install -c conda-forge matplotlib
	- conda install -c conda-forge pyarrow
	- conda install -c conda-forge py4j
	- pip install git+https://github.com/jundongl/scikit-feature.git
6.	Download and install the KNIME platform from https://www.knime.com/
7.	Open the KNIME platform and install the following extensions:
	- Weka 3.7
	- KNIME python integration
	- KNIME Parallel Chunk Loop Nodes
	- KNIME Statistics Nodes (Labs)
	- KNIME Machine Learning Interpretability Extension
8.	Open the workflow with the KNIME platform.
9.	Configure in the KNIME platform the conda environment to be used to execute the workflow: Menu – Preferences – KNIME – Python
![KNIME preferences](https://github.com/cicese-biocom/classification-QSAR-bioKom/assets/19722447/a327aa38-2350-4b7d-824d-36247164e15c)



## Workflow parameters:

|Name|Type|Value|Description|
|----|----|----|----|
|MCC_Threshold|Float|[0, 1]|Models with training MCC values greater than the threshold MCC value are selected to be assessed in test files|
|TargetFeature|String||Name of the feature to be used as target feature.|
|PathTrainingFolder|String||Path to the directory containing the training CSV file.|
|PathTestFolder|String||Path to the directory containing the test (external) CSV files.|
|Subset|String||List separated by comma with the name of the features to be used as best subset. If this list is not specified, the CFS selector is applied on the training CSV file.|
|Processors|Integer||Number of processor to be used in the workflow execution.|
|Feature_Entropy|Float|[0, 1]|Threshold to remove irrelevant features using an unsupervised Shannon Entropy (SE)-based filter. That threshold (%) is used to compute the cutoff value regarding the maximun entropy|
|Feature_Correlation|Float|[0, 1]|Threshold to remove redundant features using Pearson correlation.|
|Model_Correlation|Float|[0, 1]|Threshold to remove redundant models using Pearson correlation.|
|Perplexity|Integer||Value to be used to build the t-SNE graphics. Defaul value is 0, meaning that the perplexity value is equal to square root of the number of features.|

## Run workflow from command line:
For frequently asked questions (FQA): https://www.knime.com/faq
```
knime.exe -consoleLog -nosplash -nosave -reset -application org.knime.product.KNIME_BATCH_APPLICATION -workflowDir="workspace/Knime_project" -workflow.variable=PathTrainingFolder,path/to/csv/training/file,String -workflow.variable=PathTestFolder,path/to/csv/test/files,String -workflow.variable=MCC_Threshold,value,double -workflow.variable=TargetFeature,Feature_Name,String -workflow.variable=Processors,Number_Processors,int -workflow.variable=Feature_Correlation,Threshold_Value,double -workflow.variable=Feature_Entropy,Threshold_Value,double -workflow.variable=Model_Correlation,Threshold_Value,double
```
