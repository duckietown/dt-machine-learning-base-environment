#!/usr/bin/env python3

from datetime import datetime

print("===============================================================")
print("Importing TensorRT")
pre = datetime.now()
try:
    import tensorrt as trt
except Exception as e:
    print("TensorRT Import Error!")
    print(e)
    print("\nTensorRT requires host runtime libraries.")
    exit(1)
now = datetime.now() - pre
print("TensorRT import success! Total {} seconds".format(now.seconds))

# Check TensorRT Version
print('TensorRT version: ' + trt.__version__)

# Test TensorRT Logger
print('Testing TensorRT Logger...')
try:
    logger = trt.Logger(trt.Logger.WARNING)
    print('+    TensorRT Logger created')
except Exception as e:
    print('ERROR! Failed to create TensorRT Logger: ' + str(e))
    exit(1)

# Test TensorRT Builder
print('Testing TensorRT Builder...')
try:
    builder = trt.Builder(logger)
    print('+    TensorRT Builder created')
except Exception as e:
    print('ERROR! Failed to create TensorRT Builder: ' + str(e))
    exit(1)

# Check available plugins
print('Checking available plugins...')
try:
    registry = trt.get_plugin_registry()
    num_plugins = len(registry.plugin_creator_list)
    print('+    Plugin registry accessible ({} plugins)'.format(num_plugins))
except Exception as e:
    print('ERROR! Failed to access plugin registry: ' + str(e))
    exit(1)

print("===============================================================")
print("If you have any issues, please send the output above this line!")
exit()
