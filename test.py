from scipy import io
import numpy as np
import torch
import tensorflow
mat_file = io.loadmat('All_Data.mat')
GPM=mat_file['GPM_P']
data = {}
data['input'], data['label'] = [],[]
for i in range(GPM.shape[2]-7):
    data['input'].append(GPM[:,:,i:i+7])
    data['label'].append(GPM[:,:,i+7])

data['input'], data['label'] = np.array(data['input']), np.array(data['label'])

data['input'].shape

def getData(data,batch_size, iteration):
    n_train = len(data['input'])
    epoch = (batch_size * iteration)//n_train
    np.random.seed(epoch)
    shuffledIndex = np.random.choice(
        n_train,
        size=n_train,
        replace=False)
    start = (batch_size * iteration) % n_train

    input, bp = [], []
    for i in range(batch_size):
        j = (start+i) % n_train
        input.append(data['input'][shuffledIndex[j]])
        bp.append(data['label'][shuffledIndex[j]])

    epoch = (batch_size * iteration)//n_train
    input = torch.from_numpy((np.array(input))).permute(0,2,1).float()
    tmp = np.zeros((batch_size,len(data['input'][2]),2))
    tmp[:,:,0] = 1-np.array(bp)
    tmp[:,:,1] = np.array(bp)
    bp = torch.from_numpy(tmp).float()

    return input, bp, epoch


getData(data,7,100)
