{ config, lib, pkgs, ... }:

{
  programs.mpv = {
    enable = true;

    config = {
      osd-font-size = 14;
      osd-level = 3;
      slang = "enUS,enGB,en,eng,ptBR,pt,por";
      alang = "ja,jpn,enUS,enGB,en,eng,ptBR,pt,por";
      profile = [ "gpu-hq" "interpolation" ];
    };

    profiles = {
      color-correction = {
        target-prim = "bt.709";
        target-trc = "bt.1886";
        gamma-auto = true;
        icc-profile-auto = true;
      };

      interpolation = {
        interpolation = true;
        tscale = "box";
        tscale-window = "quadric";
        tscale-clamp = 0.0;
        tscale-radius = 1.025;
        video-sync = "display-resample";
        blend-subtitles = "video";
      };

      hq-scale = {
        scale = "ewa_lanczossharp";
        cscale = "ewa_lanczossharp";
      };

      low-power = {
        profile = "gpu-hq";
        hwdec = "auto";
        deband = false;
        interpolation = false;
      };
    };

    bindings = let
      motion-based-interpolation = ../../../mpv/.config/mpv/filters/motion-based-interpolation.vpy;
    in {
      F1 = "seek -85";
      F2 = "seek 85";
      I = "vf toggle vapoursynth=${motion-based-interpolation}";
    };
  };
}
