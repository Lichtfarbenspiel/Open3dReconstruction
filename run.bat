:: Extract frames (color and depth) and intrinsics from .mkv file. Create config.json
python azure_kinect_mkv_reader.py --input kinect_recording.mkv --output frames

:: Reconstruction pipeline
python run_system.py "%1" --make

python run_system.py "%1" --register

python run_system.py "%1" --refine

python run_system.py "%1" --integrate