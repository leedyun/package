## v0.10.6.2

- Upgrade numerizer dependency to v0.2. !3

## v0.10.6.1

-  Allow to pass `days_per_month`, `hours_per_day` as part of `opts={}` for `.parse` and `.output`. For internal calculations, use `days_per_month` to calculate `days_per_week`. Replace `days_per_week` getter/setter with `days_per_month` !2
- Configure GitLab CI !1
