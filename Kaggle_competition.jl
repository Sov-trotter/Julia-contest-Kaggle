Pkg.add("Images")
Pkg.add("DataFrames")
Pkg.add("ImageMagick")          //Windows, linux
Pkg.add("QuartzImageIO.jl")     //Mac
Pkg.add("CSV")
using Images
using DataFrames
using CSV



/typeData could be either "train" or "test.
/labelsInfo should contain the IDs of each image to be read
/The images in the trainResized and testResized data files
/are 20x20 pixels, so imageSize is set to 400.
/path should be set to the location of the data files.





function read_data(typeData, labelsInfo, imageSize, path)





 /Intialize x matrix
 

x = zeros(size(labelsInfo, 1), imageSize)

 for (index, idImage) in enumerate(labelsInfo[:ID])     //we want to index it with a symbol instead of a string i.e. lablesInfoTrain[:ID] 
  
  nameFile = "$(path)/$(typeData)Resized/$(idImage).Bmp"   //Read image file 
  img = load(nameFile)        //The replacement for imread() is load(). Depending on your platform, load() will use ImageMagick.jl or QuartzImageIO.jl (on a Mac) behind the scenes.

  
   temp=Gray.(img)            //float32sc was deprecated so we have to convert the images dirctly to gray scale which is made easy in Julia
    



  /Transform image matrix to a vector and store 
  /it in data matrix 



  x[index, :] = reshape(temp, 1, imageSize)
 end 
 return x
end
imageSize = 400 / 20 x 20 pixel

/Set location of data files, folders


path = ...



/Read information about training data , IDs.


labelsInfoTrain = CSV.read("$(path)/trainLabels.csv")  //read_table has been deprecated 

/Read training matrix


xTrain = CSV.read("train", labelsInfoTrain, imageSize, path)



/Read information about test data ( IDs ).


labelsInfoTest = CSV.read("$(path)/sampleSubmission.csv")


/Read test matrix



xTest = read_data("test", labelsInfoTest, imageSize, path)




/Get only first character of string (convert from string to character).
/Apply the function to each element of the column "Class"



yTrain = map(x -> x[1], labelsInfoTrain[:Class])


/Convert from character to integer



ytrain = convert(Array{Int64,1},ytrain) //julia considered int() as a function 
Pkg.add("DecisionTree")
using DecisionTree




/Train random forest with
/20 for number of features chosen at each random split,
/50 for number of trees,
/and 1.0 for ratio of subsampling.
model = build_forest(yTrain, xTrain, 20, 50, 1.0)
/Get predictions for test data
predTest = apply_forest(model, xTest)
/Get predictions for test data
predTest = apply_forest(model, xTest)

/Convert integer predictions to character



labelsInfoTest[:Class] = convert(Array{Char,1},predtest)



/Save predictions



CSV.write("$(path)/juliaSubmission.csv", labelsInfoTest, separator=',', header=true)
accuracy = nfoldCV_forest(yTrain, xTrain, 20, 50, 4, 1.0);
println ("4 fold accuracy: $(mean(accuracy))")
