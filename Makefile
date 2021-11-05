#---------------------------Required files-----------------------#
#Standard Gaussian Blur (serial version)
TARGET=gb_std.o
SOURCE=gaussian_blur_standard.cpp

#Pthread Gaussian Blur
TARGET_PTHREAD=gb_pthread.o
SOURCE_PTHREAD=gaussian_blur_pthread.cpp

#OpenMP Gaussian Blur
TARGET_OMP=gb_omp.o
SOURCE_OMP=gaussian_blur_omp.cpp



#Gaussian matrix generator and check matrix
TARGET_CM=cm.o
SOURCE_CM=create_matrix.cpp
TARGET_CHECK=check.o
SOURCE_CHECK=check_matrix.cpp

#diff the cuda, unpadded pic
TARGET_DIFF=diff.o
SOURCE_DIFF=diff_image.cpp
TARGET_UNPADDED=gb_std_unpadded.o
SOURCE_UNPADDED=gaussian_blur_unpadded.cpp

#------------------------Compiler and flag-----------------------#
#Compilers
CPP=g++
MPICC=mpicc
NVCC=nvcc
#LIBS and FLAGS
PTHREAD_LIBS=-pthread 
OTHER_LINS=-lm
CPP_FLAGS=-std=c++11 
OPENCV=`pkg-config --cflags --libs opencv4`

#---------------------------Rules-------------------------------#
#Rules for standard Gaussian Blur (serial version)
all: standard pthread omp cuda cuda_shm cuda_stm
do_diff: diff standard omp cuda cuda_shm cuda_stm

standard: $(SOURCE_UNPADDED)
	$(CPP) $(SOURCE_UNPADDED) -o $(TARGET_UNPADDED) $(CPP_FLAGS) $(OPENCV)

#Rules for pthread Gaussian Blur
pthread: $(SOURCE_PTHREAD)
	$(CPP) $(SOURCE_PTHREAD) -o $(TARGET_PTHREAD) $(CPP_FLAGS) $(PTHREAD_LIBS) $(LIBS) $(OPENCV)

#Rules for OpenMp Gaussian Blur
omp: $(SOURCE_OMP)
	$(CPP) $(SOURCE_OMP) -o $(TARGET_OMP) $(CPP_FLAGS) -fopenmp $(LIBS) $(OPENCV)

#Rules for diff image
diff: $(SOURCE_DIFF)
	$(CPP) $(SOURCE_DIFF) -o $(TARGET_DIFF) $(CPP_FLAGS)

#Rules for Gaussian matrix generator
matrix: create_matrix.cpp
	$(CPP) $(SOURCE_CM) -o $(TARGET_CM) $(CPP_FLAGS) 
	$(CPP) $(SOURCE_CHECK) -o $(TARGET_CHECK) $(CPP_FLAGS) 

.PHONY: clean

clean:
	rm -f *.o
