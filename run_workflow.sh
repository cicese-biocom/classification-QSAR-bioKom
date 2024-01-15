#!/bin/bash

knime -consoleLog -nosplash -nosave -reset -application org.knime.product.KNIME_BATCH_APPLICATION -workflowFile="./classification-QSAR-bioKom.knwf" -workflow.variable=PathTrainingFolder,/opt/data/training/,String -workflow.variable=PathTestFolder,/opt/data/test/,String -workflow.variable=MCC_Threshold,0.5,double -workflow.variable=TargetFeature,Activity,String -workflow.variable=Feature_Entropy,0.25,double -workflow.variable=Feature_Correlation,0.95,double -workflow.variable=Model_Correlation,0.7,double -workflow.variable=Processors,10,int -preferences=knime_preferences.epf
