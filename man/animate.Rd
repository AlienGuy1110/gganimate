% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/animate.R, R/gganim.R
\name{animate}
\alias{animate}
\alias{animate.gganim}
\alias{print.gganim}
\alias{knit_print.gganim}
\title{Render a gganim object}
\usage{
animate(plot, ...)

\method{animate}{gganim}(
  plot,
  nframes,
  fps,
  duration,
  detail,
  renderer,
  device,
  ref_frame,
  start_pause,
  end_pause,
  rewind,
  ...
)

\method{print}{gganim}(x, ...)

knit_print.gganim(x, options, ...)
}
\arguments{
\item{plot, x}{A \code{gganim} object}

\item{...}{Arguments passed on to the device.
For available device arguments, see \code{\link[grDevices:png]{grDevices::png()}} or \code{\link[grDevices:cairo]{grDevices::svg()}}}

\item{nframes}{The number of frames to render (default \code{100})}

\item{fps}{The framerate of the animation in frames/sec (default \code{10})}

\item{duration}{The length of the animation in seconds (unset by default)}

\item{detail}{The number of additional frames to calculate, per frame (default \code{1})}

\item{renderer}{The function used to render the generated frames into an
animation. Gets a vector of paths to images along with the framerate. (default \code{\link[=gifski_renderer]{gifski_renderer()}})}

\item{device}{The device to use for rendering the single frames. Possible
values are \code{'png'}, \code{'ragg_png'} (requires the ragg package), \code{'jpeg'},
\code{'tiff'}, \code{'bmp'}, \code{'svg'}, and \code{'svglite'} (requires the svglite package).
(default \code{'png'})}

\item{ref_frame}{The frame to use for fixing dimensions of the plot, e.g. the
space available for axis text. Defaults to the first frame. Negative values
counts backwards (-1 is the last frame) (default \code{1})}

\item{start_pause, end_pause}{Number of times to repeat the first and last
frame in the animation (default is \code{0} for both)}

\item{rewind}{Should the animation roll back in the end (default \code{FALSE})}

\item{options}{chunk options for the currently executing chunk}
}
\value{
The return value of the \link[=renderers]{renderer} function
}
\description{
This function takes a gganim object and renders it into an animation. The
nature of the animation is dependent on the renderer, but defaults to using
\code{gifski} to render it to a gif. The length and framerate is decided on render
time and can be any two combination of \code{nframes}, \code{fps}, and \code{duration}.
Rendering is happening in discrete time units. This means that any event in
the animation is rounded of to the nearest frame (e.g. entering will always
take a whole number of frames). This means that rounding artifacts are
possible when only rendering few frames. To avoid this you can increase the
\code{detail} argument. \code{detail} will get multiplied to \code{nframes} and the
resulting number of frames will get calculated, but only \code{nframes} evenly
spaced frames are rendered.
}
\details{
\code{print.gganim}()  is an alias for \code{animate()} in the same way as
\code{print.ggplot()} is an alias for \code{plot.ggplot()}. This ensures that gganimate
behaves ggplot2-like and produces the animation when the object is printed.
The \code{plot()} method is different and produces a single frame for inspection
(by default frame 50 out of 100).

Animations can be saved to disk using \code{\link[=anim_save]{anim_save()}} in much the same way
\link[ggplot2:ggsave]{ggsave()} works for static plots.
}
\section{Defaults}{

It is possible to overwrite the defaults used by gganimate for the animation
by setting them with \code{\link[=options]{options()}} (prefixed with \code{gganimate.}. As an example,
if you would like to change the default nframes to 50 you would call
\code{options(gganimate.nframes = 50)}. In order to set default device arguments
(those you would normally pass through with \code{...}) you should use the
\code{gganimate.dev_args} options and provide a list of arguments e.g.
\code{options(gganimate.dev_args = list(width = 800, height = 600))} Defaults set
this way can still be overridden by giving arguments directly to \code{animate()}.

\strong{knitr Support:} \cr
It is possible to specify the arguments to \code{animate()} in the chunk options
when using \code{gganimate} with \code{knitr}. Arguments specified in this way will
have precedence over defaults, but not over arguments specified directly in
\code{animate()}. The arguments should be provided as a list to the \code{gganimate}
chunk option, e.g. \verb{\{r, gganimate = list(nframes = 50, fps = 20)\}}. A few
build-in knitr options have relevance for animation and will be used unless
given specifically in the \code{gganimate} list option. The native knitr options
supported are:
\itemize{
\item \code{dev}: will set \code{device}
\item \code{dev.args}: will set additional arguments to the device (\code{...})
\item \code{fig.width}, \code{fig.height}, \code{fig.asp}, \code{fig.dim}: will set \code{width} and
\code{height} of the device.
}
}

\section{Label variables}{

All plots have a certain set of variables available for string literal
interpolation within plot labels. These are:
\itemize{
\item \strong{frame} gives you the frame index for the current frame
\item \strong{nframes} gives you the total number of frames in the animation
\item \strong{progress} gives you the progress of the animation at the current frame
(equal to \code{frame/nframes})
\item \strong{data} gives you the layer data for the current frame (as a list of data
frames)
}

Further, the transition and view in use can also make variables available.
Consult the documentation for these for more detail.
}

\examples{
anim <- ggplot(mtcars, aes(mpg, disp)) +
  transition_states(gear, transition_length = 2, state_length = 1) +
  enter_fade() +
  exit_fade()

\dontrun{
# Explicitly animate using default (same as just printing the animation)
animate(anim)

# Change duration and framerate
animate(anim, fps = 20, duration = 15)

# Make the animation pause at the end and then rewind
animate(anim, nframes = 100, end_pause = 10, rewind = TRUE)

# Use a different renderer
animate(anim, renderer = file_renderer('~/animation/'))[1:6]

# Specify device dimensions and/or resolution
animate(anim, height = 2, width = 3, units = "in", res = 150)
}

}
