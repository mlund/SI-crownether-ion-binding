import numpy as _np

def plot_free_energy(xall, yall, weights=None, ax=None, nbins=50, ncountours=100,
                     avoid_zero_count=True, minener_zero=True, kT=1.0, vmin=None, vmax=None,
                     cmap='spectral', cbar=True, cbar_label='Free energy (kT)', white_bg=True):
    """Free energy plot given 2D scattered data
    Builds a 2D-histogram of the given data points and plots -log(p) where p is
    the probability computed from the histogram count.
    Parameters
    ----------
    xall : ndarray(T)
        sample x-coordinates
    yall : ndarray(T)
        sample y-coordinates
    weights : ndarray(T), default = None
        sample weights. By default all samples have the same weight
    ax : matplotlib Axes object, default = None
        the axes to plot to. When set to None the default Axes object will be used.
    nbins : int, default=100
        number of histogram bins used in each dimension
    ncountours : int, default=100
        number of contours used
    avoid_zero_count : bool, default=True
        avoid zero counts by lifting all histogram elements to the minimum value
        before computing the free energy. If False, zero histogram counts will
        yield NaNs in the free energy which and thus regions that are not plotted.
    minener_zero : bool, default=True
        Shifts the energy minimum to zero. If false, will not shift at all.
    kT : float, default=1.0
        The value of kT in the desired energy unit. By default, will compute
        energies in kT (setting 1.0). If you want to measure the energy in
        kJ/mol at 298 K, use kT=2.479 and change the cbar_label accordingly.
    vmin : float or None, default=0.0
        Lowest energy that will be plotted
    vmax : float or None, default=None
        Highest energy that will be plotted
    cmap : matplotlib colormap, optional, default = None
        The color map to use. None will use pylab.cm.spectral.
    cbar : boolean, default=True
        Plot a color bar
    cbar_label : str or None, default='Free energy (kT)'
        Colorbar label string. Use None to suppress it.
    white_bg : boolean, dfault=True
        Adds the color white to the highest value in the color map.
    Returns
    -------
    fig : Figure object containing the plot
    ax : Axes object containing the plot
    CS : Mappable object containing the values of the plot
    """
    import matplotlib.pylab as _plt
    cmap = cmap
    if white_bg == True:
        mod_cmap = _plt.cm.get_cmap(cmap)
        mod_cmap.set_over('white')
        cmap = mod_cmap
    # histogram
    z, xedge, yedge = _np.histogram2d(xall, yall, bins=nbins, weights=weights)
    x = 0.5*(xedge[:-1] + xedge[1:])
    y = 0.5*(yedge[:-1] + yedge[1:])
    # avoid zeros
    if avoid_zero_count:
        zmin_nonzero = _np.min(z[_np.where(z > 0)])
        z = _np.maximum(z, zmin_nonzero)
    # compute free energies
    F = -kT * _np.log(z)
    if minener_zero:
        F -= _np.min(F)
    # do a contour plot
    extent = [yedge[0], yedge[-1], xedge[0], xedge[-1]]
    if ax is None:
        plot = None
        CS = None
    else:
        plot = _plt.gca()
        CS = ax.contourf(x, y, F.T, ncountours, extent=extent, cmap=cmap, vmin=vmin, vmax=vmax)
        if cbar:
            cbar = _plt.colorbar(CS)
            if cbar_label is not None:
                cbar.ax.set_ylabel(cbar_label)

    return plot, ax, CS, (x,y,z)
