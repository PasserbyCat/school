Predictive Maintenance in MATLAB
1. About Predictive Maintenance->p3
2. Predictive Maintenance Solution->p9
3. datastore & feature extraction->p15
4. Machine Learning->p24
5. RUL->p27
matlab軟體實作
1. 安裝 : Predictive Maintenance Toolbox
2. 練習一 : HOME>New Live Section開啟即時運行的新專案
            LIVE EDITOR>CODE>Code可宣告現在輸入的行為code(此區有註解功能，但直接使用百分比%符號即可註解)
            LIVE EDITOR>TEXT>Text可宣告現在輸入的行為text(可在此區旁邊的功能對其做字形字體的調變)
            LIVE EDITOR>SECTION>Section Break可將code分段執行(利用Run Section)
3. 練習二 : 語法>%{多行註解內容%}
4. 練習三 : categorical可將類別名稱變成字典用byte對應節省空間
            APPS>diagnosticFeatureDesigner開啟分析工具(亦可藉由指令開啟)
            FEATURE DESIGNER>New Session>Source(選擇想要分析的資源)>注意label必須是Condition Variable而非Signal>Import
            FEATURE DESIGNER(在Variables中選擇想要分析的數據)>PLOT>Signal Trace
            FEATURE DESIGNER(在Variables中選擇想要分析的數據)>FEATURE GENERATION>Time-Domain Features>Signals Features
            SIGNAL FEATURES(可選擇想要留下來的變因)>CLOSE>Apply
            FEATURE DESIGNER(在Variables中選擇想要觀察的特徵表)>PLOT>Feature Table View
            FEATURE DESIGNER>RANKING>Rank Features(選擇想要排序的特徵表)
            FEATURE RANKING>METHODS>Supervised Ranking>選擇想要的分析法(該分析法下可能有其他參數可以調整，另行調整後再做Apply也可行)>Apply>Close參數名
            FEATURE RANKING>SORT>Sort by(此處可多選新增的分析法)
            FEATURE DESIGNER>DATA PROCESSING>Spetral Estimation(選擇轉頻率的方法)
            OREDER SPECTRUM>WINDOWING METHOD>Window Type(可選擇觀察頁面)
            OREDER SPECTRUM>CLOSE>Apply
            OREDER SPECTRUM>VIEW>Group By(選擇用什麼做排序)
            OREDER SPECTRUM>VIEW>Number of Curves(選擇要多少個參數)
            OREDER SPECTRUM>VIEW>Number of Peaks to Mark(要標註多少個峰值)
            FEATURE DESIGNER>Variables(轉頻率後會出現SpectrumData)>FEATURE GENERATION>Fequency-Domain Features>Spectral Features
            SPECTRAL FEATURES>FRQUENCY BAND(可設定想取頻域的範圍)
            SPECTRAL FEATURES>CLOSE>Apply
            FEATURE DESIGNER>RANKING>Rank Features(選擇想要排序的特徵表)
            FEATURE DESIGNER>EXPORT>Export>Export features to the MATLAB workspace(可以選擇想要的features數量)->此參數會出現在workspace
            FEATURE DESIGNER>EXPORT>Export>Generate FunctionFor Features(選擇要存的特徵數和分析方法)>OK(此時會生成一個檔，可將其儲存)
            附註 : Diagnostic Feature Designer裡>FEATURE DESIGNER>FILE>Save Session(可將現在的狀態存起來，將來可用Open Session開啟)
5. matlab線上 : 在網頁登錄後，頭巷旁的九宮格可選MATLAB，應該會出現Online版，可使用的功能一樣。
6. 練習四 : APPS>Classification Learner
            CLASSIFICATION LEARNER>FILE>New Session>/Data Set Variable(記得選擇要分析的資料)
                                                    /Response(要記得選成想要的結果)
                                                    /Validation(選擇不同的方法)>/Cross-Validation(ABCDE選四個訓練，測試最後一個，共執行五次)
                                                                               /Holdout Validation(切割25%出來預測，其餘拿來訓練)
                                                                               /Resubstitution Validation(全部拿來訓練)
            CLASSIFICATION LEARNER>MODELS(選一個方法train)
            CLASSIFICATION LEARNER>MODELS>All Quick-To-Train
            CLASSIFICATION LEARNER>TRAIN>Use Parallel(平常請預設關閉，此功能會開啟電腦的多核心運算)
            CLASSIFICATION LEARNER>TRAIN>Train All
            CLASSIFICATION LEARNER>PLOTs>Confusion Matrix(可開啟F1-score的圖表)
            CLASSIFICATION LEARNER>OPTIONS>Costs(可調整各格的權重，權重越高該區錯誤率越低，因為越看重其正確率)
            CLASSIFICATION LEARNER>MODELS>Medium KNN>Misclassification Costs: Custom(可察看權重)
            CLASSIFICATION LEARNER>EXPORT>Export Model>Export Model>OK
其他
1. 在ex4_2_predicting_RUL.m這個檔案裡有其中一種預測RUL的方法(預測RUL的方法共有三大類型)
2. 在matlab上方有個"?"顯示help，會顯示搜尋視窗，有各種工具箱以及他的範例