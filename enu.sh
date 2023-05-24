#!/bin/bash

# Ask for the target domain
read -p "Enter the target domain: " targetDomain

# Run subfinder
subfinder -d "$targetDomain" -t 100 -v -o /home/kali/Desktop/target/subfinder.txt

# Run amass enum
amass enum -ip -brute -d "$targetDomain" -o /home/kali/Desktop/target/amass.txt

# Run crt.sh
cd ./crt.sh
./crt.sh "$targetDomain" > /home/kali/Desktop/target/crt.txt
cd ..

# Combine the three files and remove duplicates
cat /home/kali/Desktop/target/subfinder.txt /home/kali/Desktop/target/amass.txt /home/kali/Desktop/target/crt.txt | sort -u > /home/kali/Desktop/target/subdomains.txt

# Run httpx on subdomains.txt
cat /home/kali/Desktop/target/subdomains.txt | httpx -threads 200 | tee -a /home/kali/Desktop/target/final_subdomains.txt

# Run waybackurls on final_subdomains.txt
cat /home/kali/Desktop/target/final_subdomains.txt | waybackurls | tee -a /root/Desktop/waybackurls.txt
