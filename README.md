1. Check the ionospheric corrections in folder ~/fig_ion

2. Decide if mask(s) is needed for ionospheric corrections. Usually only need to mask out isolated areas and decorrelated areas. If so, obtain box coordinates of the mask(s) by viewing a bad corrected interferogram:
$ cd ~/pairs_ion/??????-??????/ion/ion_cal
$ mdx.py diff_??????-??????_80rlks_448alks.int

See alosStack.xml for more details on the format of the box coordinates.

If an irregular shape is needed for the masked area, obtain the box coordinates more easily by doing the following:
$ cd ~/pairs_ion/??????-??????/ion/ion_cal
$ execute alosStack_iono2ppm.py, the output is out.ppm

Open out.ppm in GIMP (https://www.gimp.org), paint the areas to be masked black, and save as PNG ensuring that the image size remains the same. Then run the MATLAB code alosStack_ionoMask2Coord.m to obtain the box coordinates.

3. Copy the obtained box coordinates to your alosStack.xml as:
<property name="areas masked out in ionospheric phase estimation">[your_box_coordinates]</property>

4. Re-run create_cmd.py

5. Re-run the script to do ionospheric estimation
