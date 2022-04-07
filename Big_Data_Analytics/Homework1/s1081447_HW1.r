library(dplyr)
library(stringr)
x = read.csv("HW1.csv", header = T, sep = ",")
y = data.frame(x)
#觀察下無特殊值
y$A1.... = gsub(",", ".", y$A1....)#將,換成.
y$A1.... = as.numeric(y$A1....)
#觀察下無特殊值
y$A2.... = gsub(",", ".", y$A2....)
y$A2.... = as.numeric(y$A2....)
#有特殊值，僅大的有影響
y$A22.... = gsub(",", "", y$A22....)
tmp1 = mutate(y ,long = str_length(y$A22....)) %>% filter(long > 4)
y = mutate(y ,long = str_length(y$A22....)) %>% filter(long <= 4)
tmp1$A22.... = substr(tmp1$A22...., start = 1, stop = 4)
y = rbind(y, tmp1)
y$A22.... = paste(substr(y$A22...., start = 1, stop = 2),
                  substr(y$A22...., start = 3, stop = 4),
                  sep = ".")
y$A22.... = as.numeric(y$A22....)
#有特殊值，僅大的有影響
y$A23.... = gsub(",", "", y$A23....)
tmp1 = mutate(y ,long = str_length(y$A23....)) %>% filter(long > 3)
y = mutate(y ,long = str_length(y$A23....)) %>% filter(long <= 3)
tmp1$A23.... = substr(tmp1$A23...., start = 1, stop = 4)
y = rbind(y, tmp1)
y$A23.... = paste(substr(y$A23...., start = 1, stop = 1),
                  substr(y$A23...., start = 2, stop = 3),
                  sep = ".")
y$A23.... = as.numeric(y$A23....)
#有特殊值，且大小皆有影響(小攸關補零)
y$A3 = gsub(",", "", y$A3)#讓他變成純粹由數字組成的字串
tmp1 = mutate(y ,long = str_length(y$A3)) %>% filter(long > 6)#觀察下發現大多數為6個數字
tmp2 = mutate(y ,long = str_length(y$A3)) %>% filter(long < 6)
y = mutate(y ,long = str_length(y$A3)) %>% filter(long == 6)
tmp1$A3 = substr(tmp1$A3, start = 1, stop = 6)#超過的尾數全部捨棄
tmp2$A3 = str_pad(tmp2$A3, 6, side = "right", "0")#少於6位數的後面補0,補成六位數
y = rbind(y, tmp1, tmp2)
y$A3 = paste(substr(y$A3, start = 1, stop = 4),
             substr(y$A3, start = 5, stop = 6),
             sep = ".")#觀察下發現大多在倒數兩位的地方有,故在四五位之間補.
y$A3 = as.numeric(y$A3)

cn = paste0("A", c(4:21))#剩下所有的多在三位後補,預測為千位分隔符
for (i in cn) {#其實其他筆也可以放進for迴圈,只要多一點條件就好了
  y[, i] = gsub(",", "", y[, i])#直接將逗點處理掉
  tmp = mutate(y ,long = str_length(y[, i])) %>% count(long)
  avlen = tmp[which.max(tmp$n), "long"]#用來判斷位數的眾數在哪裡
  #同樣大小都有影響
  tmp1 = mutate(y ,long = str_length(y[,i])) %>% filter(long > avlen)
  tmp2 = mutate(y ,long = str_length(y[,i])) %>% filter(long < avlen)
  y = mutate(y ,long = str_length(y[,i])) %>% filter(long == avlen)
  tmp1[,i] = substr(tmp1[,i], start = 1, stop = avlen)
  tmp2[,i] = str_pad(tmp2[,i], avlen, side = "right", "0")
  
  y = rbind(y, tmp1, tmp2)
  y[,i] = as.numeric(y[,i])
}
y[,-grep("long",colnames(y))]#最終結果(將新增的long取消)
