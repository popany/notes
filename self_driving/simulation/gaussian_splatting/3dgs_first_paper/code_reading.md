# 3DGS First Paper Code Reading

- [3DGS First Paper Code Reading](#3dgs-first-paper-code-reading)
  - [Paper](#paper)
  - [optimization variable](#optimization-variable)

## Paper

[3D Gaussian Splatting for Real-Time Radiance Field Rendering](https://arxiv.org/abs/2308.04079)

## optimization variable

    class GaussianModel:
        ...

        self._xyz
        self._features_dc
        self._features_rest
        self._scaling
        self._rotation
        self._opacity

- `_xyz`

  Gaussian center points.

  Shape: (n, 3)

- `_features_dc`

  Shape: (n, 1, 3)

- `self._features_rest`

  Shape: (n, 15, 3) with sh_degree = 3

- `self._scaling`

  Shape: (n, 3)

- `self._rotation`

  Shape: (n, 4)

- `self._opacity`

  Shape: (n, 1)









