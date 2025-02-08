{ ... }: {
  # --- Import each subfolder as a namespace in snowman
  snowman = {
    programs = import ./programs;
  };
}
