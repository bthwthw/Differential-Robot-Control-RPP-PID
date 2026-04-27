# Differential-Robot-Control-RPP-PID
This project simulates a three-wheeled differential drive robot performing trajectory tracking using the **RPP (Regulated Pure Pursuit) Law** for path following and **auto-tuning PID controllers** for motor speed regulation. 

## Project Overview
The simulation focuses on a differential drive system where the motors are identified using system identification techniques to obtain the transfer functions for both left and right wheels.

### Key Features:
* **System Identification:** Motor dynamics are characterized by coefficients $a_1, a_2, b_1, b_2$ for precise control.
* **Path Following:** Implementation of the **RPP Law** to guide the robot along a predefined trajectory.
* **Low-level Control:** Dual PID controllers for independent motor speed synchronization.
* **Trajectory:** Rectangular path tracking.

## System Architecture
1.  **Trajectory Generator:** Inputs a custom rectangular path.
2.  **Kinematic Controller (RPP):** Calculates required linear ($v$) and angular ($\omega$) velocities.
3.  **Dynamic Controller (PID):** Adjusts motor voltages based on the identified $a, b$ coefficients.

## How to Run
To run the simulation, follow these steps in MATLAB:
1.  Open the project folder.
2.  Run `init.m` to load parameters, identified coefficients, and controller gains.
3.  Run `sim_result.m` to visualize the performance graphs.

## Results and Analysis
The simulation provides the following output plots:
* **Robot's Trajectory:** 2D mapping of the robot's movement vs. reference path.
* **Cross-track Error:** Deviation from the planned trajectory.
* **Heading Angle:** Orientation of the robot over time.
* **Velocity Profiles:** Both Linear and Angular velocities.

## References
This project implements the Regulated Pure Pursuit algorithm as described in:
* **S. Macenski, S. Singh, F. Martin, J. Gines, "Regulated Pure Pursuit for Robot Path Tracking," *Autonomous Robots*, 2023.**

## Technologies Used
* MATLAB & Simulink
* System Identification Toolbox
* Control System Toolbox
