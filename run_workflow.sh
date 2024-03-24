#!/bin/bash

training_file_path=/opt/data/training/
test_files_path=/opt/data/test/
mcc_threshold=0.5
target_feature_name=Activity
feature_entropy_threshold=0.25
feature_correlation_threshold=0.95
model_correlation_threshold=0.95
processor_numbers=1

knime -consoleLog -nosplash -nosave -reset -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="classification-QSAR-bioKom.knwf" -workflow.variable=PathTrainingFolder,$training_file_path,String -workflow.variable=PathTestFolder,$test_files_path,String -workflow.variable=MCC_Threshold,$mcc_threshold,double -workflow.variable=TargetFeature,$target_feature_name,String -workflow.variable=Feature_Entropy,$feature_entropy_threshold,double -workflow.variable=Feature_Correlation,$feature_correlation_threshold,double -workflow.variable=Model_Correlation,$model_correlation_threshold,double -workflow.variable=Processors,$processor_numbers,int -preferences=knime_preferences.epf
