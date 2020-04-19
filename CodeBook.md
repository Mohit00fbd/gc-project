# CodeBook

The script ```run_analysis.R``` performs data wrangling as directed on the project page.  

### 1. Download the data
* The script first checks whether data directory exists or not. If not, data directory is created.
* Once, checked, the files are downloaded using the download.file method.
* The files downloaded are in zipped format. They're unzipped using the unzip method.
* Once the files are extracted, they're listed in the console for inspection.

### 2. Read data files
* Read ```x_train, y_train and subject_train files``` and combine those using ```cbind``` command into ```train``` variable.
* Do the same with test data and store it in ```test``` variable.
* Combine the data into ```activity_reco``` variable using ```rbind``` command.

### 3. Rename the columns to give descriptive names
* Use the ```features.txt``` file and append ```activity and subject``` character strings to it.
* Use ```make.names``` function to make valid names for dataframe.
* Using ```gsub``` expand some of the abbreviated terms.

### 4. Select only mean, standard deviation, activity and subject fields.
* Using ```dplyr select and contains``` function select only columns containing ```mean, std, activity and subject``` in column names.

### 5. Relabel activity names
* Use ```activity_labels.txt``` file to be used as levels and convert activity column into factor and relabel activity numbers.

### 6. Summarise data
* Use ```summarise_all``` function after grouping by activity and subject to calculate mean and store it in ```avg_data``` variable
* Resulting dataset is stored in text file named ```resulting_data.txt```