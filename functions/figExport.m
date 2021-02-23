function figExport(w,h,name)
formatFig(w,h)
print(gcf, '-dpdf', strcat(pwd, '/figures/', name, '.pdf'));
% exportgraphics(gcf, strcat(pwd, '/figures/', name, '.pdf'), 'ContentType', 'vector');

    function formatFig(w,h)
        fig = gcf;
        fig.PaperOrientation = 'landscape';
        fig.PaperSize = [w h];
        fig.PaperPosition = [0 0 w h];
        fig.Renderer = 'Painters'; % for 3D plots
        % fig.Units = 'centimeters';
        % fig.Position = [0 0 w h];
    end
end