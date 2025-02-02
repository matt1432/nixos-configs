using System;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel.Entities;


namespace NetDaemonConfig.Apps.Frontend.BathroomLight
{
    [NetDaemonApp]
    public class BathroomLight
    {
        public BathroomLight(Services services, Entities entities)
        {
            LightEntity? bathroomLight = entities.Light.Tz3210KatchgxyTs0505bLight;
            InputTextEntity? bathroomLightBrightness = entities.InputText.BathroomLightBrightness;

            var brightnessCallback = (Action<double, double> callback) =>
            {
                double? currentBrightness = bathroomLight?.Attributes?.Brightness;

                if (currentBrightness is not null)
                {
                    double currentBrightnessPercent = Math.Floor((double)currentBrightness / 2.54);
                    double inputBrightnessPercent = Double.Parse(bathroomLightBrightness.State ?? "0");

                    if (currentBrightnessPercent != inputBrightnessPercent)
                    {
                        callback(currentBrightnessPercent, inputBrightnessPercent);
                    }
                }
            };

            bathroomLightBrightness
                .StateAllChanges()
                .Subscribe((_) => brightnessCallback((current, input) =>
                {
                    services.Light.TurnOn(
                        target: ServiceTarget.FromEntity("light.tz3210_katchgxy_ts0505b_light"),
                        brightness: Math.Floor(input * 2.54 + 1));
                }));

            bathroomLight
                .StateAllChanges()
                .Subscribe((_) => brightnessCallback((current, input) =>
                {
                    bathroomLightBrightness.SetValue(current.ToString());
                }));

            // Init value
            brightnessCallback((current, input) =>
                {
                    bathroomLightBrightness.SetValue(current.ToString());
                });
        }
    }
}
