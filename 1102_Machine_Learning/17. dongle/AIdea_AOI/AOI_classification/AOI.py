# ******************************************************************************
#  Copyright (c) 2021. Kneron Inc. All rights reserved.                        *
# ******************************************************************************

from os import listdir
from utils.ExampleHelper import get_device_usb_speed_by_port_id
import kp
import cv2
import numpy as np
import pandas as pd
import csv
import time
import os
import sys
import argparse

#先設定路徑
PWD = os.path.dirname(os.path.abspath(__file__))
SCPU_FW_PATH = os.path.join(PWD, './firmware/kdp2_fw_scpu.bin')
NCPU_FW_PATH = os.path.join(PWD, './firmware/kdp2_fw_ncpu.bin')
MODEL_FILE_PATH = os.path.join(PWD, './models/aoi.nef')
IMAGE_FILE_PATH = os.path.join(PWD, './res/images')


"""
post-process utils

modified from (path in toolchain docker): /workspace/ai_training/classification/inference.py
"""


def softmax(A):
    #請輸入程式碼
    return


def postprocess(pre_output):
    score = softmax(pre_output)
    return score


def run():
    global IMAGE_FILE_PATH
    usb_port_id = 0

    """
    connect the device
    """
    try:
        print('[Connect Device]')
        #請輸入程式碼
        print(' - Success')
    except kp.ApiKPException as exception:
        print('Error: connect device fail, port ID = \'{}\', error msg: [{}]'.format(usb_port_id,
                                                                                     str(exception)))
        exit(0)

    """
    setting timeout of the usb communication with the device
    """
    print('[Set Device Timeout]')
    kp.core.set_timeout(device_group=device_group, milliseconds=5000)
    print(' - Success')

    """
    upload firmware to device
    """
    try:
        print('[Upload Firmware]')
        #請輸入程式碼
                                     
                                        
        print(' - Success')
    except kp.ApiKPException as exception:
        print('Error: upload firmware failed, error = \'{}\''.format(str(exception)))
        exit(0)

    """
    upload model to device
    """
    try:
        print('[Upload Model]')
        #請輸入程式碼
                                                           
        print(' - Success')
    except kp.ApiKPException as exception:
        print('Error: upload model failed, error = \'{}\''.format(str(exception)))
        exit(0)

    """
    prepare the image
    """
    print('[Read Image]')

    model_input_height = model_nef_descriptor.models[0].height
    model_input_width = model_nef_descriptor.models[0].width
    model_input_channel = model_nef_descriptor.models[0].channel

    #讀取test_img
    #請輸入程式碼

    
    
    
     
     
    

    print(' - Success')
    """
    prepare app generic inference config
    """
    size = len(IMG_LIST)
    """
    starting inference work
    """
    print('[Starting Inference Work]')
    print(' - Starting inference loop {} times'.format(size))
    print(' - ', end='')

    result = []

    times = []
    for i in range(len(IMG_LIST)):
        try:
            ''' prepare aligned NPU input data buffer '''
            #請輸入程式碼

            ''' resize / padding input data to model input size '''
            #請輸入程式碼

            ''' simulation of hardware KP_NORMALIZE_KNERON normalization (BGR/2.0) '''
            #請輸入程式碼

            ''' fill input data to aligned NPU input data buffer '''
            #請輸入程式碼

            ''' change image color space to BGRA '''
            #請輸入程式碼

            ''' convert to binary buffer '''
            img_aligned_buffer = img_aligned_bgra.tobytes()

            generic_raw_image_header = kp.GenericRawBypassPreProcImageHeader(
                model_id=model_nef_descriptor.models[0].id,
                image_buffer_size=len(img_aligned_buffer),
                inference_number=0
            )

            start = time.time()

            kp.inference.generic_raw_inference_bypass_pre_proc_send(device_group=device_group,
                                                                    generic_raw_image_header=generic_raw_image_header,
                                                                    image_buffer=img_aligned_buffer)

            generic_raw_result = kp.inference.generic_raw_inference_bypass_pre_proc_receive(device_group=device_group,
                                                                                            generic_raw_image_header=generic_raw_image_header,
                                                                                            model_nef_descriptor=model_nef_descriptor)

            end = time.time()
            times.append(end-start)
            """
            retrieve inference node output 
            """
            inf_node_output_list = []
            
            for node_idx in range(generic_raw_result.header.num_output_node):
                inference_float_node_output = kp.inference.generic_inference_retrieve_float_node(node_idx=node_idx,
                                                                                            generic_raw_result=generic_raw_result,
                                                                                            channels_ordering=kp.ChannelOrdering.KP_CHANNEL_ORDERING_CHW)
                inf_node_output_list.append(inference_float_node_output)
            

            tmp = []
            for o_n in inf_node_output_list:
                o_array = o_n.ndarray.copy()
                tmp.append(o_array)

            res = postprocess(tmp)
            result.append(np.argmax(res))
            
            
        except kp.ApiKPException as exception:
            print(' - Error: inference failed, error = {}'.format(exception))
            exit(0)



    # 輸出預測結果
    with open('./output/cur_output.csv', 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['ID','Predicted'])
        for i in range(size):
            writer.writerow([IMG_NAME[i],result[i]])

    #準確率
    test_csv_data = pd.read_csv('./utils/aoi_test.csv')
    count = 0.
    list1 = [0] * 10

    for i in range(size):
        A = test_csv_data.loc[test_csv_data["ID"]==IMG_NAME[i]].reset_index(drop=True)
        if result[i] == A["Label"][0]:
            count += 1
        else:
            list1[A["Label"][0]] += 1
    
    print("\naccuracy: ", count / size)

    #一秒跑幾張
    time_total = 0.0
    for i in range(size):
        time_total += times[i]

    print(time_total,"秒")
    print(size/time_total,"張/秒")     

if __name__ == '__main__' :
    path = 'IMAGE_FILE_PATH'
    run()