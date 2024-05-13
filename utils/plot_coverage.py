import matplotlib.pyplot as plt
def get_lines_with_prefix(file_path, prefix):
    try:
        flag = False
        # Open the file in read mode
        with open(file_path, 'r') as file:
            # Initialize a list to store lines with the prefix
            numbers = []
            # Iterate through each line in the file
            for line in file:
                if not flag and "Corpus import finished" in line:
                    flag = True
                # Check if the line starts with the specified prefix
                if flag and line.startswith(prefix):
                    prefix_index = line.find(prefix)
                    # If the line starts with the prefix, append it to the list
                    if prefix_index != -1:
                        # Extract the substring after the prefix
                        substring = line[prefix_index + len(prefix):].strip()
                        # Split the substring by whitespace
                        parts = substring.split()
                        # Iterate through parts and attempt to convert to float
                        for part in parts:
                            try:
                                if part.endswith("%"):
                                    number = float(part[:-1])
                                    numbers.append(number)
                                else:
                                    number= float(part)
                                    numbers.append(number)
                            except ValueError:
                                pass
            # If the prefix is not found in any line
            if not numbers:
                print("Error: Prefix '{}' not found in the file.".format(prefix))
            return numbers
    except FileNotFoundError:
        print("File not found.")
        return []
plt.xlabel('Total Samples')
plt.ylabel('Coverage')
plt.title('Coverage trend w.r.t Total Samples')
# Example usage
file_path = 'result5.txt'

total_samples = get_lines_with_prefix(file_path, "Total Samples:")
print(len(total_samples))
interesting_samples = get_lines_with_prefix(file_path, "Interesting Samples Found:")
print(len(interesting_samples))
coverages = get_lines_with_prefix(file_path, "Coverage:")
print(len(coverages))
if len(total_samples) > len(coverages):
    total_samples = total_samples[:-1]
plt.plot(total_samples, coverages, label='New Model')

file_path = 'result4.txt'
total_samples = get_lines_with_prefix(file_path, "Total Samples:")
print(len(total_samples))
interesting_samples = get_lines_with_prefix(file_path, "Interesting Samples Found:")
print(len(interesting_samples))
coverages = get_lines_with_prefix(file_path, "Coverage:")
print(len(coverages))
if len(total_samples) > len(coverages):
    total_samples = total_samples[:-1]
plt.plot(total_samples, coverages, label='Baseline')

# Add legend
plt.legend()
plt.savefig("tmp.jpg")
# Show the plot
plt.show()