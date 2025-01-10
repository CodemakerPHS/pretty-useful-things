[1] "Dataset comprises 66 observations of 9 variables. \n "
[1] "This dataset uses integer for age, whereas we treat age as an ordinal categorical variable, using age groups."
Rows: 66
Columns: 9
$ patient_id <chr> "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", …
$ age        <int> 61, 68, 62, 61, 58, 46, 67, 68, 53, 59, 72, 45, 58, 44, 58, 42, 48, 68, 82, 71, 84, 68, 64, 62, 56, 72, 72, 54,…
$ gender     <chr> "0", "1", "1", "1", "1", "1", "1", "0", "1", "0", "0", "1", "0", "1", "0", "1", "0", "0", "0", "0", "1", "1", "…
$ bmi        <dbl> 20.79721, 27.30000, 22.18310, 35.26846, 22.67334, 27.69035, 28.95731, 19.83399, 17.55142, 27.72287, 22.71064, 4…
$ smoking    <chr> "2", "0", "0", "2", "1", "1", "2", "0", "0", "2", "1", "1", "2", "0", "0", "0", "1", "1", "2", "2", "2", "1", "…
$ exercise   <chr> "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "…
$ fruit      <dbl> 1, 0, 1, 2, 3, 0, 0, 3, 1, 1, 1, 1, 0, 2, 2, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 3, 0, 3, 0, 1, 1, 2, 1, 1, …
$ veg        <dbl> 2, 1, 3, 4, 1, 2, 3, 4, 3, 3, 2, 2, 3, 4, 4, 6, 1, 5, 2, 3, 0, 3, 3, 5, 5, 4, 4, 3, 2, 2, 2, 1, 3, 3, 4, 2, 2, …
$ cancer     <chr> "0", "0", "0", "0", "0", "1", "1", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "1", "0", "0", "0", "…
[1] "Minimum age: "
[1] 39
[1] "Maximum age:"
[1] 89
[1] "Values for gender: "
[1] "0" "1"
[1] "0" "1" "2"
[1] 0
[1] 9
# A tibble: 1 × 0
  patient_id             age           gender               bmi          smoking            exercise             fruit      
 Length:66          Min.   :39.00   Length:66          Min.   :10.81   Length:66          Length:66          Min.   :0.000  
 Class :character   1st Qu.:54.00   Class :character   1st Qu.:21.41   Class :character   Class :character   1st Qu.:0.000  
 Mode  :character   Median :61.00   Mode  :character   Median :24.78   Mode  :character   Mode  :character   Median :1.000  
                    Mean   :61.02                      Mean   :24.22                                         Mean   :1.015  
                    3rd Qu.:69.75                      3rd Qu.:27.30                                         3rd Qu.:2.000  
                    Max.   :89.00                      Max.   :40.62                                         Max.   :4.000  
      veg           cancer         
 Min.   :0.000   Length:66         
 1st Qu.:2.000   Class :character  
 Median :3.000   Mode  :character  
 Mean   :2.985                     
 3rd Qu.:4.000                     
 Max.   :9.000                     
