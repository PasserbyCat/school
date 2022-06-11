[瑕疵類別]
*用來對照輸出之label
0:"normal"
1:"void"
2:"edge"
3:"partical"
4:"scratches"
5:"rolled-in_scale"
6:"pitted_surface"
7:"patches"
8:"inclusion"
9:"crazing"


----------------------------------------------------


[環境建置]
*本app只適用於windows系統
*請先自行安裝anaconda
*路徑名稱請勿使用中文

1.打開工作管理員，滑鼠點開左上角的檔案 – 執行新工作，在輸入框中輸入 cmd
2.輸入conda create --name [myenv] python=3.8   # myenv可自行命名
3.輸入conda activate [myenv]    # 開啟環境
4.使用cd 指令進入./AOI_classification/package資料夾
5.輸入pip install -r requirements.txt

sudo apt install libusb-1.0-0-dev
-----------------------------------------------------


[進行推論]
1.進入cmd，並且插上耐能棒
2.進入路徑./AOI_classification/
3.輸入python AOI.py
4.等待結果輸出，也可下download csv，至 ./AOI_classification/output 底下查看csv檔