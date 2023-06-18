# geodetic to enu

- [geodetic to enu](#geodetic-to-enu)
  - [Geodetic to ECEF](#geodetic-to-ecef)
    - [geodetic to ecef formulas](#geodetic-to-ecef-formulas)
  - [ECEF to/from ENU](#ecef-tofrom-enu)

[Geographic coordinate conversion](https://en.wikipedia.org/wiki/Geographic_coordinate_conversion)

[govert/GpsUtils.cs](https://gist.github.com/govert/1b373696c9a27ff4c72a)

[Transformations between ECEF and ENU coordinates](https://gssc.esa.int/navipedia/index.php/Transformations_between_ECEF_and_ENU_coordinates)

[Source code for pyltg.utilities.latlon](https://www.nsstc.uah.edu/users/phillip.bitzer/python_doc/pyltg/_modules/pyltg/utilities/latlon.html)

[sbarratt/geo.py](https://gist.github.com/sbarratt/a72bede917b482826192bf34f9ff5d0b)

[World Geodetic System](https://en.wikipedia.org/wiki/World_Geodetic_System)

[Local tangent plane coordinates](https://en.wikipedia.org/wiki/Local_tangent_plane_coordinates)

[Geodetic coordinates](https://en.wikipedia.org/wiki/Geodetic_coordinates)

## Geodetic to ECEF

ref: [From geodetic to ECEF coordinates](https://en.wikipedia.org/wiki/Geographic_coordinate_conversion#From_geodetic_to_ECEF_coordinates)

ref: [World Geodetic System - Definition](https://en.wikipedia.org/wiki/World_Geodetic_System#Definition)

The WGS 84 datum surface is an oblate spheroid with equatorial radius $a = 6378137 m$ at the equator and flattening $f = 1/298.257223563$.

This leads to several computed parameters such as the polar semi-minor axis $b$ which equals $a \times (1 − f) = 6356752.3142 m$, and the first eccentricity squared, $e^{2} = 6.69437999014 \times 10^{−3}$.

### geodetic to ecef formulas

$$
X = \left( N \left( \phi \right) + h \right) cos\phi cos\lambda
\\ Y = \left( N \left( \phi \right) + h \right) cos\phi sin\lambda
\\ Z = \left( \left( 1 - e^{2} \right) N \left( \phi \right) + h \right) sin\phi
$$

where

$$
N \left( \phi \right) = \frac{a}{\sqrt{1 - e^{2} sin^{2}\phi}}
\\ e^2 = f \left( 2 - f \right)
\\ f = 1 / 298.257223563
\\ a = 6378137 
$$

## ECEF to/from ENU

$$
\begin{bmatrix} x \\ y \\ z \end{bmatrix} = \begin{bmatrix} - \sin \lambda_r & \cos \lambda_r & 0 \\ - \sin \phi_r \cos \lambda_r & - \sin \phi_r \sin \lambda_r & \cos \phi_r \\ \cos \phi_r \cos \lambda_r & \cos \phi_r \sin \lambda_r & \sin \phi_r \end{bmatrix} \begin{bmatrix} X_p - X_r \\ Y_p - Y_r \\ Z_p - Z_r \end{bmatrix} 
$$

$$
\begin{bmatrix} X_p \\ Y_p \\ Z_p \end{bmatrix} = \begin{bmatrix} - \sin \lambda_r & - \sin \phi_r \cos \lambda_r & \cos \phi_r \cos \lambda_r \\ \cos \lambda_r & - \sin \phi_r \sin \lambda_r & \cos \phi_r \sin \lambda_r \\ 0 & \cos \phi_r & \sin \phi_r \end{bmatrix} \begin{bmatrix} x \\ y \\ z \end{bmatrix} + \begin{bmatrix} X_r \\ Y_r \\ Z_r \end{bmatrix}
$$

$\lambda_r$ and $\phi_r$ come form geodetic coordinate of origin point. $\left( X_r, Y_r, Z_r \right)$ is ECEF coordinate of origin point. $\left( x, y, z \right)$ is in ENU coordinate.

