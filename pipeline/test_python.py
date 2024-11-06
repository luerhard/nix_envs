import src
import torch

if __name__ == "__main__":
    try:
        df = src.load.sample_data()
        print(f"Python load sucess: {df.shape}")
        print(f"CUDA available: {torch.cuda.is_available()}")
    except:
        print("Load Failure python")
        raise
