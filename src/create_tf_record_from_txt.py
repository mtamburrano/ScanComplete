import os
import struct
import numpy as np
import tensorflow as tf
import argparse


def _float_feature(ndarray):
  return tf.train.Feature(float_list=tf.train.FloatList(value=ndarray.flatten().tolist()))
  
def _int_feature(ndarray):
  return tf.train.Feature(int64_list=tf.train.Int64List(value=ndarray.flatten().tolist()))



def create_record(filename):

  sdf_txt = [line.rstrip() for line in open(filename)]
  sdf_numpy  = np.array(sdf_txt[3:]).astype("float")
  str_dims = sdf_txt[0].split(" ")
  dims = np.array([int(str_dims[0]), int(str_dims[1]), int(str_dims[2])])

  #input_block = np.ones([46,48,17]) * -float("inf")
  input_block = sdf_numpy.reshape(dims)

  output_record_file = 'dummy.tfrecords'

  writer = tf.python_io.TFRecordWriter(output_record_file)

  feature = {'input_sdf': _float_feature(input_block),
             'input_sdf/dim': _int_feature(dims)}

  example = tf.train.Example(features=tf.train.Features(feature=feature))
  writer.write(example.SerializeToString())




def main():
  
  parser = argparse.ArgumentParser(description='create tfrecord from txt sdf')
  parser.add_argument('-p', '--path_sdf', required=True, help='path to input txt sdf')
  args = parser.parse_args()
  
  create_record(args.path_sdf)
  
  


if __name__ == "__main__": main()
