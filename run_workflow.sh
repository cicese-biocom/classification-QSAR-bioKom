#!/bin/bash

path_train=/opt/data/training/
path_test=/opt/data/test/
mcc_threshold=0.5
target_feature=Activity
feature_entropy=0.25
feature_correlation=0.95
model_correlation=0.95
processors_numbers=1

knime -consoleLog -nosplash -nosave -reset -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="classification-QSAR-bioKom.knwf" -workflow.variable=PathTrainingFolder,$path_train,String -workflow.variable=PathTestFolder,$path_test,String -workflow.variable=MCC_Threshold,$mcc_threshold,double -workflow.variable=TargetFeature,$target_feature,String -workflow.variable=Feature_Entropy,$feature_entropy,double -workflow.variable=Feature_Correlation,$feature_correlation,double -workflow.variable=Model_Correlation,$model_correlation,double -workflow.variable=Processors,$processors_numbers,int -preferences=knime_preferences.epf
