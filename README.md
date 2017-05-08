### LFD_MPIV_Toolbox v2.0

## Description
LFD_MPIV_Toolbox is a Matlab (R) Toolbox aimed at obtaining tomographic - phase
averaged PIV fields from Hamamatsu CXD files. The application for which it is
developed is micro fluidic (imaging through inverted microscope) and thus some
default choice reflect that. This toolbox is heavily inspired by (and some files
are portion of) the PIVlab Toolbox (http://pivlab.blogspot.com/), which might be
a better choice as a generic solution for PIV.

## Features
The main features that commended the development of this package over the use
of PIVlab are:

- Support of CXD files (for the moment, the only format accepted).

- Phase reconstruction using frequencies or matlab files with time stamps for
  actuation and acquisition.

- Cumulative cross-correlation for phase averaging.

- Most options supported in PIVlab are supported here.

## Installation

- clone or download and unzip the repository

- add path of LFD_MPIV_TOOLBOX to MATLAB path

- LFD_MPIV_Interface or LFD_MPIV_CommandLine('my_cxd_file.cxd')

## Issues

  Many bugs are still present, please report at:

  https://github.com/tduriez/LFD_MPIV_Toolbox/issues


## Copyright and License

  All files in this toolbox are Copyright (c) 2017, Thomas Duriez at the
  exception of:

- dctn.m (Damien Garcia -- 2008/06)

- idctn.m (Damien Garcia -- 2009/04)

- inpaint_nans.m (John D'Errico 2006)

- smoothn.m (Damien Garcia -- 2009/03, http://www.biomecardio.com/matlab/smoothn.html)

  and

  -filter_fields.m
  -find_all_displacements.m
  -prepare_image.m

  Which contains parts copied from the PIVlab Toolbox (see in files for license).

  The toolbox is distributed under the GPLv3 License.

  Have fun. T.

--------------------------------------------------------------------------------
    Copyright (c) 2017, Thomas Duriez

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
