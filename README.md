# Tokyo Midtown Medical Center J-Tele-Doctor Project

## Project Overview
Tokyo Midtown Medical Center (TMMC) is expanding its medical care services by introducing a J-Tele-Doctor platform. This platform aims to assist customers who prefer remote consultations to avoid spreading sickness or are located abroad. This initiative is part of TMMC's strategy to enhance their services in anticipation of future pandemics. Despite offers from Azure Japan, AWS Japan has been selected for this project. The application will be accessible to both local and international customers and will support multiple languages.

## Stage One Objectives
In this initial stage, the following tasks must be completed:

1. **Local Application Hosting**: Deploy the application in the following locations:
    - Tokyo
    - New York
    - London
    - Sao Paulo
    - Australia
    - Hong Kong
    - California

2. **Local Requirements**: Each deployment location must meet these criteria:
    - **Auto Scaling Group (ASG)** with a minimum of 2 Availability Zones (AZs)
    - At least **1 EC2 instance** for the current test deployment
    - Deployment in a security zone to transfer syslog data and demonstrate the ability to transfer data to Japan
    - Public access limited to **port 80** only

3. **Project Limitations**: The following constraints must be strictly adhered to:
    - Syslog data must be stored exclusively in Japan. The SIEM/Syslog server will be deployed in Stage Two.
    - No personal information can be stored outside Japan's borders, and such data cannot be transferred via VPN.
    - Databases will be deployed in Stage Two.
    - The Availability Zone containing syslog data must be limited to a private subnet.

---

## Future Stages
- **Stage Two**: Deployment of SIEM/Syslog server and databases.

---

This project will enhance TMMC's service offerings and ensure robust, secure, and scalable solutions for remote medical consultations.
