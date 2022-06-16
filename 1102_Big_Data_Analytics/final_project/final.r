train = read.csv("train.csv", header = T)
test = read.csv("test.csv", header = T)
test$Transported = NA
all = rbind(train, test)#一起前處理，不然好麻煩

###多重資料同一欄位
# #PassengerId
# temp = all$PassengerId %>% str_split(pattern="_", simplify=TRUE)
# all$IdGroup = temp[, 1] %>% as.integer()
# all$IdNum = temp[, 2] %>% as.integer()
#Cabin(此處有遺漏值)
temp = all$Cabin %>% str_split(pattern="/", simplify=TRUE)
all$CabinDeck = temp[, 1]
all$CabinNum = temp[, 2] %>% as.integer()
all$CabinSide = temp[, 3] %>% 
                str_replace(pattern="P", replace="Port") %>% 
                str_replace(pattern="S", replace="StarBoard")
# #Name(此處有遺漏值)
# temp = all$Name %>% str_split(pattern=" ", simplify=TRUE)
# all$FirstName = temp[, 1]
# all$LastName = temp[, 2]
all = all[ , -which(colnames(all) %in% c("PassengerId","Cabin", "Name"))]

###數值化
#T/F
all$CryoSleep = as.integer(all$CryoSleep == "True")
all$VIP = as.integer(all$VIP == "True")
#字串
# all[which(all$Destination == "TRAPPIST-1e"),"DestinationT"] = 1
# all[which(all$Destination == "PSO J318.5-22"),"DestinationP"] = 1
# all[which(all$Destination == "55 Cancri e"),"Destination5"] = 1
# 
# all[which(all$HomePlanet == "Europa"),"HomePlanetU"] = 1
# all[which(all$HomePlanet == "Earth"),"HomePlanetE"] = 1
# all[which(all$HomePlanet == "Mars"),"HomePlanetM"] = 1

all[which(all$CabinDeck == "A"),"CabinDeckA"] = 1
all[which(all$CabinDeck == "B"),"CabinDeckB"] = 1
all[which(all$CabinDeck == "C"),"CabinDeckC"] = 1
all[which(all$CabinDeck == "D"),"CabinDeckD"] = 1
all[which(all$CabinDeck == "E"),"CabinDeckE"] = 1
all[which(all$CabinDeck == "F"),"CabinDeckF"] = 1
all[which(all$CabinDeck == "G"),"CabinDeckG"] = 1
all[which(all$CabinDeck == "T"),"CabinDeckT"] = 1

all[which(all$CabinSide == "Port"),"CabinSideP"] = 1
all[which(all$CabinSide == "StarBoard"),"CabinSideS"] = 1

all = all[ , -which(colnames(all) %in% c("Destination","HomePlanet", "CabinDeck", "CabinSide"))]

###fill NA
all$Age[is.na(all$Age)] = mean(all$Age, na.rm = T)
all$CabinNum[is.na(all$CabinNum)] = -1
# all = all[ , -which(colnames(all) %in% c("Age", "CabinNum"))]

all$Transported = as.integer(all$Transported == "True")
all$Transported[is.na(all$Transported)] = 2

#付費使用，沒資料應該是沒付費，設為0/one hot編碼亦出現NA，設為0
all[is.na(all)] = 0
# all$Cost %>% mutate(RoomService + FoodCourt + ShoppingMall + Spa + VRDeck)
# all = all[ , -which(colnames(all) %in% c("RoomService","FoodCourt", "ShoppingMall", "Spa", "VRDeck"))]
all[which(all$Transported == 2),"Transported"] = NA

###將all切割回來
train = all[!is.na(all$Transported),]
test = all[is.na(all$Transported),]

###build model
library(randomForest)
nfold = 4
set.seed(0)
split_data = split(sample(1:nrow(train)), 1:nfold)#分成四份
str(split_data)

accuracy = function(actual, pred){sum(actual == pred) / length(actual)}
pred = rep(0, nrow(train))

for (i in 1:nfold){
  this_train = train[-split_data[[i]],]
  this_pred = train[split_data[[i]],]
  model = randomForest(Transported~., data=this_train)
  pred[split_data[[i]]] = predict(model, newdata=this_pred, type="response")
}

model = randomForest(Transported~., data=train)
summary(model)
pred = predict(model, newdata=test, type="response")
pred = as.integer(0.5 <= pred)

sub = read.csv("sample_submission.csv")
sub$Transported = sapply(pred, FUN=function(x){if (x==1){"True"} else {"False"}})
write.csv(sub, "submission.csv", row.names=FALSE)
