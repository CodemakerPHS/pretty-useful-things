# Add text to 
# "QPI Dataset Fields vX.X.xlsx" 

library(openxlsx2)


QPI_Dataset_Fields_wb <- openxlsx2::read_xlsx("/PHI_conf/CancerGroup2/Cancer_QPIs/R_individual_folders/pauline_code/input_data/metadata/QPI Dataset Fields v1.0.PW.xlsx")

# not working
# cancers_sheets <- openxlsx2::wb_get_sheet_names(QPI_Dataset_Fields_wb)
