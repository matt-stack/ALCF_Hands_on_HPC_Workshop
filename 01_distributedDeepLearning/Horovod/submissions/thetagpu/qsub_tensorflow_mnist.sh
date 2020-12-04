#!/bin/bash
#COBALT -n 2
#COBALT -t 1:00:00 -q full-node
#COBALT -A SDL_Workshop -O results/thetagpu/$jobid.tensorflow_mnist

#submisstion script for running tensorflow_mnist with horovod

echo "Running Cobalt Job $COBALT_JOBID."

#Loading modules

source /lus/theta-fs0/software/thetagpu/conda/tf_master/latest/mconda3/setup.sh

mpirun -x LD_LIBRARY_PATH -x PATH -x PYTHONPATH -np 16 --hostfile $COBALT_NODEFILE  -npernode 8 python tensorflow2_mnist.py --device gpu --epochs 16 >& results/thetagpu/tensorflow2_mnist.n16.out

for n in 1 2 4 8
do
    mpirun -np $n python tensorflow2_mnist.py --device gpu --epochs 16 >& results/thetagpu/tensorflow2_mnist.n$n.out & 
done
wait
