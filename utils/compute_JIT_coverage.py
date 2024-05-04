import os

# Directory path
directory = '/home/jiahui/tmpJIT'
profdir = '/home/jiahui/v8/v8/out/cov/profrawJIT'
profdata = 'JIT.profdata'
d8 = 'home/jiahui/v8/v8/out/cov/d8'
result = "/home/jiahui/cov.txt"
total = 1000
counter = 0

# Get a list of all files in the directory
files = [os.path.join(directory, filename) for filename in os.listdir(directory)]

# Sort files based on creation time
files.sort(key=os.path.getctime, reverse = True)

# Process files in the order of their creation time
for file_path in files:
    if file_path.endswith('.js'):
        counter += 1
        print(file_path)
        os.system(f'LLVM_PROFILE_FILE="{profdir}/{os.path.basename(file_path)[:-3]}.profraw" ./d8 --expose-gc --omit-quit --allow-natives-syntax {file_path}')
        if(counter == total):
            break

# merge all .porfraw file

profraw_files = [os.path.join(profdir, filename) for filename in os.listdir(profdir) if filename.endswith('.profraw')]
command = f"llvm-profdata-18 merge -o {profdata} {' '.join(profraw_files)}"
os.system(command)


# filter only JIT Compiler coverage
command = f"llvm-cov-18 report -instr-profile {profdata} -object {d8} --ignore-filename-regex='^(../../include|../../src/(api|base|common|codegen)|../../src/[d-z]|../../third|gen|../../base)' > {result}"